require 'pp'

module CmdBox
  # command =
  #   expression action
  # expression =
  #   boolean_exp
  #   | boolean_exp conj
  # boolean_exp =
  #   field comparator identifier
  # field =
  #   period identifier
  # action =
  #   filter
  #   select

  class << self
    def parse(str)
      $logger.info "parsing #{str}"

      tokens = lexer(str)
      parser = Parser.new
      ast = parser.parse(tokens)

      return ast
    end

    def lexer(str)
      str.split(/\s+/)
        .select { |t| t.length > 0 }
    end
  end

  class Parser
    def initialize
    end

    def parse(tokens)
      @index = 0
      @token_stack = []
      @tokens = tokens
      return ingest_token { |token|
        command(token)
      }.tap { |ast| $logger.info pp(ast) }
    end

    def ingest_token(&block)
      token = @tokens.shift
      return nil if token.nil?
      @token_stack.push(token)
      result = block.call(token)
      @index += token.length
      return result
    end

    def unwind_token(num)
      num.times do
        token = @token_stack.pop
        next if token.nil?
        @tokens.unshift(token)
        @index -= token.length
        $logger.info "tokens: #{@tokens}"
        $logger.info "stack : #{@token_stack}"
      end
    end

    def commit_ingestion
      @token_stack = []
    end

    def node_error?(node)
      return !node[:error].nil?
    end

    def append_error_to(node, errmsg)
      node[:error] = errmsg
      return node
    end

    def command(token)
      node = { type: :command, value: nil, children: [], pos: @index }

      $logger.info "command: #{token}"
      child_node = expression(token)
      if node_error?(child_node)
        unwind_token(1)
        return append_error_to(node, "Need expression")
      end
      node[:children].push(child_node)

      ingest_token do |token|
        child_node = action(token)
        if node_error?(child_node)
          unwind_token(2)
          return append_error_to(node, "Need action")
        end
        node[:children].push(child_node)
      end

      commit_ingestion

      return node
    end

    def action(token)
      $logger.info "action: #{token}"

      case token
      when "filter"
        return { type: :action, value: token, children: [], pos: @index }
      when "select"
        return { type: :action, value: token, children: [], pos: @index }
      else
        return { type: :action, value: nil, children: [], pos: @index, error: "Not valid action" }
      end
    end

    def expression(token)
      $logger.info "expression: #{token}"
      node = { type: :expression, value: nil, children: [], pos: @index }

      child_node = boolean_exp(token)
      if node_error?(child_node)
        unwind_token(1)
        return append_error_to(node, "Need boolean expression")
      end
      node[:children].push(child_node)

      # optional node
      ingest_token do |token|
        child_node = boolean_op(token)
        if node_error?(child_node)
          unwind_token(1)
          return node
        end
        node[:children].push(child_node)
      end

      #injest_token do |token|

      commit_ingestion

      return node
    end

    def boolean_exp(token)
      $logger.info "boolean_exp: #{token}"
      node = { type: :boolean_exp, value: nil, children: [], pos: @index }

      child_node = field(token)
      if node_error?(child_node)
        $logger.info "not a field"
        unwind_token(1)
        return append_error_to(node, "Need to start with field name")
      end
      node[:children].push(child_node)

      ingest_token do |token|
        child_node = comparator(token)
        if node_error?(child_node)
          unwind_token(2)
          return append_error_to(node, "Need comparator")
        end
        node[:children].push(child_node)
      end

      ingest_token do |token|
        child_node = identifier(token)
        if node_error?(child_node)
          unwind_token(3)
          return append_error_to(node, "Need identifier")
        end
        node[:children].push(child_node)
      end

      commit_ingestion

      return node
    end

    def boolean_op(token)
      $logger.info "boolean_op: #{token}"
      case token
      when "and"
        return { type: :boolean_op, value: "and", children: [], pos: @index }
      when "or"
        return { type: :boolean_op, value: "or", children: [], pos: @index }
      else
        return { type: :boolean_op, value: nil, children: [], pos: @index, error: "Not valid boolean operation" }
      end
    end

    def field(token)
      $logger.info "field: #{token}"
      if token =~ /\.[\d\w]+/
        return { type: :field , value: token, children: [], pos: @index }
      else
        return { type: :field , value: token, children: [], pos: @index, error: "Not valid field" }
      end
    end

    def comparator(token)
      $logger.info "comparator: #{token}"
      case token
      when "="
        return { type: :comparator, value: token, children: [], pos: @index }
      when "!="
        return { type: :comparator, value: token, children: [], pos: @index }
      when "<"
        return { type: :comparator, value: token, children: [], pos: @index }
      when ">"
        return { type: :comparator, value: token, children: [], pos: @index }
      when "<="
        return { type: :comparator, value: token, children: [], pos: @index }
      when ">="
        return { type: :comparator, value: token, children: [], pos: @index }
      else
        return { type: :comparator, value: token, children: [], pos: @index, error: "Not valid comparator"}
      end
    end

    def identifier(token)
      $logger.info "identifier: #{token}"
      if token =~ /[\d\w]+/
        return { type: :identifier, value: token, children: [], pos: @index }
      else
        return { type: :identifier, value: token, children: [], pos: @index, error: "Not valid identifier" }
      end
    end

  end

end

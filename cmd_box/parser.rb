require_relative './rule'

module CmdBox
  class Parser
    class << self
      include CmdBox::Rule

      def parse(tokens)
        @index = 0
        @token_stack = []
        @tokens = tokens
        return ingest_token { |token|
          command(token)
        }.tap { |ast| $logger.info ast }
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
        end
        $logger.info "unwind #{num} tokens: #{@tokens.to_s}"
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

      def match(rule_proc, parent_node, &errblock)
        child_node = rule_proc.call
        return errblock.call if node_error?(child_node)

        parent_node[:children].push(child_node)
        return node
      end
    end
  end

end

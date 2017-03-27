require_relative './parser'
require_relative './ast_transformer'

module CmdBox
  class << self
    def parse(str)
      $logger.info "parsing #{str}"

      tokens = lexer(str)
      ast = Parser.parse(tokens)

      return ast
    end

    def ast_to_msg(ast)
      AstTransformer.transform(ast)
    end

    def lexer(str)
      str.split(/\s+/)
        .select { |t| t.length > 0 }
    end
  end
end

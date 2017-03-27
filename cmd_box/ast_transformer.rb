module CmdBox
  module AstTransformer
    class << self

      def transform(node)
        msg = {}
        msg[:type] = find_action(node)
        $logger.info "msg: #{msg.to_s}"

        return msg
      end

      def find_action(node)
        if node[:type] == :action
          return node[:value]
        else
          node[:children].each do |child_node|
            action = find_action(child_node)
            return action unless action.nil?
          end
          return nil
        end
      end

    end
  end
end

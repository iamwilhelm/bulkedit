module CmdBox
  module AstTransformer
    class << self

      def transform(node)
        msg = {}
        msg[:type] = find_value(:action, node)
        msg[:fields] = find_values(:field, node, []).map { |f| f.gsub(/\./, '') }

        if msg[:type].nil? && !msg[:fields].empty?
          msg[:type] = :highlight_field
        end

        msg[:type] = msg[:type].to_sym

        $logger.info "ast to msg: #{msg.to_s}"

        return msg
      end

      def find_value(msg_type, node)
        if node[:type] == msg_type
          return node[:value]
        else
          node[:children].each do |child_node|
            value = find_value(msg_type, child_node)
            return value unless value.nil?
          end
          return nil
        end
      end

      def find_values(msg_type, node, vals)
        if node[:type] == msg_type
          vals.push(node[:value])
          return vals
        else
          node[:children].each do |child_node|
            vals = find_values(msg_type, child_node, vals)
            $logger.info vals
          end
          return vals
        end
      end

    end
  end
end

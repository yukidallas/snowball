module Snowball
  module Config

    class << self
      def attr_boolean(accessor,default=false)
        class_eval <<-EVAL
        attr_writer :#{accessor.to_s}
        def #{accessor.to_s}?
          (@#{accessor.to_s} == true || #{default})
        end
        EVAL
      end
    end

    attr_boolean :debug_mode, false
    attr_boolean :use_slack, false
    attr_boolean :use_streaming, false
    attr_boolean :use_multi_client, false

    def config
      @config ||= load_config
    end

    def load_config
      @config = YAML.load_file('config/keys.yml')
    end

  end
end
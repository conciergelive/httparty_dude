module HTTPartyDude
  class ClientFactory
    class Resource
      URI_PARAMETER_REGEX = /(?<=%{)(.*?)(?=})/
      def initialize(template, *args)
        @template = template
        @args = args
      end

      def parameter_replacements
        replacements = {}
        path_parameters.each_index do |index|
          replacements[path_parameters[index].to_sym] = @args[index]
        end
        replacements
      end

      def path_parameters
        @path_parameters ||= @template.scan(URI_PARAMETER_REGEX).flatten
      end

      def path
        if path_parameters.empty?
          @template
        else
          @template % parameter_replacements
        end
      end
    end

    def self.create(configuration)
      class_name = configuration[:class_name]
      namespace = self.name.split('::').first
      # define a class with the name from the configuration
      eval("module ::HTTPartyDude::Clients; class #{class_name} < ::HTTPartyDude::Clients::Base; end; end;")
      # get a reference to the newly defined class
      class_reference = Object.const_get "HTTPartyDude::Clients::#{class_name}"
      class_reference.send(:base_uri, configuration[:base_uri])
      class_reference.pre_request_processor = configuration[:pre_request_processor]
      class_reference.response_processor = configuration[:response_processor]
      add_endpoint_methods(class_reference, configuration[:methods])      
      class_reference
    end

    def self.add_endpoint_methods(class_reference, method_configurations)
      method_configurations.each_pair do |method_name, endpoint|
        class_reference.define_singleton_method(method_name) do |*args|
          # TODO - Validate end points
          # Raise and explain any configurations issues
          endpoint_template = endpoint.keys.first
          http_method = endpoint.values.first.downcase
          # TODO - Validate arguments
          # Raise if there are not enough arguments to satisfy Ruby's string replacement.
          # This way the developer knows what they need to change and why.
          resource_path = Resource.new(endpoint_template, *args).path
          options = args.last.is_a?(Hash) ? args.last : {}

          case http_method
          when 'get'
            self.get_resource(resource_path, options)
          when 'post'
            self.post_resource(resource_path, options)
          when 'put'
            self.put_resource(resource_path, options)
          when 'delete'
            self.delete_resource(resource_path, options)
          end
        end
      end
    end
  end
end

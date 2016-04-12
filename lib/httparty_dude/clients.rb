module HTTPartyDude
  module Clients
    class Base
      include HTTParty
      @pre_request_processor = nil
      @response_processor = nil

      class << self
        attr_accessor :pre_request_processor, :response_processor
      end

      def self.delete_resource(path, options)
        pre_request_processor.call(self, 'DELETE', path, options) if pre_request_processor
        r = delete(path, options)
        response_processor.nil? ? r : response_processor.call(r) 
      end

      def self.get_resource(path, options)
        pre_request_processor.call(self, 'GET', path, options) if pre_request_processor
        r = get(path, options)
        response_processor.nil? ? r : response_processor.call(r)         
      end

      def self.post_resource(path, options)
        pre_request_processor.call(self, 'POST', path, options) if pre_request_processor
        r = post(path, options)
        response_processor.nil? ? r : response_processor.call(r)         
      end      

      def self.put_resource(path, options)
        pre_request_processor.call(self, 'PUT', path, options) if pre_request_processor
        r = put(path, options)
        response_processor.nil? ? r : response_processor.call(r)         
      end            
    end
  end
end

module HTTPartyDude
  module Clients
    class Base
      include HTTParty

      def self.delete_resource(*args)
        path = args.first
        options = args.last 
        delete(path, options)
      end

      def self.get_resource(*args)
        path = args.first
        options = args.last 
        get(path, options)
      end

      def self.post_resource(*args)
        path = args.first
        options = args.last 
        post(path, options)
      end      

      def self.put_resource(*args)
        path = args.first
        options = args.last 
        put(path, options)
      end            
    end
  end
end

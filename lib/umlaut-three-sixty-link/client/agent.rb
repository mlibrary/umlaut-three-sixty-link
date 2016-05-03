module UmlautThreeSixtyLink
  module Client
    class Agent

      def initialize(base_url, open_timeout, read_timeout)
        @base_url     = base_url
        @open_timeout = open_timeout
        @read_timeout = read_timeout
      end

      def handle(metadata, context_object)
        transport = OpenURL::Transport.new(
          @base_url,
          context_object,
          :open_timeout => @open_timeout,
          :read_timeout => @read_timeout
        )
        transport.extra_args['version'] = '1.0'
        transport.get
        RecordList.from_xml(transport.response)
      end

    end
  end
end

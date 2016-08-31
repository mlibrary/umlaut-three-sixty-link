# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module UmlautThreeSixtyLink
  module Client
    class Agent
      def initialize(base_url, open_timeout, read_timeout)
        @base_url     = base_url
        @open_timeout = open_timeout
        @read_timeout = read_timeout
      end

      def get_direct_link(co)
        if co.referent.metadata['link_model'] == 'DirectLink'
          lg = LinkGroup.new
          lg.urls.direct_link = co.referent.metadata['link']
          lg
        end
      end

      def handle(_, context_object)
        transport = OpenURL::Transport.new(
          @base_url,
          context_object,
          open_timeout: @open_timeout,
          read_timeout: @read_timeout
        )
        direct_link = get_direct_link(context_object)
        transport.extra_args['version'] = '1.0'
        transport.get
        record_list = RecordList.from_xml(transport.response)

        if direct_link
          if record_list.empty?
            # TODO: Create an empty record, and attach the direct_link to it.
          elsif record_list.link?
            record_list.each do |record|
              if record.link?
                record.links.unshift(direct_link)
                break
              end
            end
          else
            record_list.first.links.unshift(direct_link)
          end
        end

        record_list
      end
    end
  end
end

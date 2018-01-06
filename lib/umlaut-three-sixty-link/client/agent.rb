# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

module UmlautThreeSixtyLink
  module Client
    # Encapsulate the user-agent to query 360Link.
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
          lg.urls.source = co.referent.metadata['link']
          lg.holdings.database_name = 'Link provided by Summon'
          lg
        end
      end

      def handle(request)
        context_object = request.to_context_object
        transport = OpenURL::Transport.new(
          @base_url,
          context_object,
          open_timeout: @open_timeout,
          read_timeout: @read_timeout
        )
        direct_link = get_direct_link(context_object)
        transport.extra_args['version'] = '1.0'
        begin
          transport.get
          record_list = RecordList.from_xml(transport.response)
        rescue Net::ReadTimeout, Errno::ECONNREFUSED => e
          record_list = FailedRecordList.new(e)
        end

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

class ThreeSixtyLink < Service
  required_config_params :base_url
  attr_reader :base_url

  # Call super at the end of configuring defaults
  def initialize(config)
    @display_name      = '360 Link Resolver'
    @display_text      = 'Get Full Text via 360 Link'
    @http_open_timeout = 3
    @http_read_timeout = 5
    @credits           = {
      'SerialsSolutions' => 'http://www.serialssolutions.com/en/services/360-link'
    }

    # Call super to get @base_url, @open_timeout, and @read_timeout
    super

    @client = UmlautThreeSixtyLink::Client::Agent.new(
      @base_url,
      @open_timeout,
      @read_timeout
    )
  end

  # Returns an array of strings.
  # Used by auto background updater.
  def service_types_generated
    [
      ServiceTypeValue['fulltext'],
      ServiceTypeValue['holding'],
      ServiceTypeValue['highlighted_link']
    ]
  end

  def handle(request)
    records = @client.handle(request.referent.metadata, request.to_context_object)
    records.each do |record|
      base = { service: self, service_type_value: 'fulltext' }
      record.add_service(request, base)
    end

    request.dispatched(self, true)
  end
end


using Garden

class Garden::Domain::Dispatcher

  def initialize nodes, port
    @syslog = Domain::ComponentFactory::instance.create_system_log self
    @nodes = nodes
    @port = port
  end

  def dispatch_artifacts subject, device
      request = params[:request]
      responses = []

      @nodes.each do |node|
        uri_string = "#{node}:#{@port}/artifacts/#{subject}/#{device}"
        @@syslog.info "submitting to node: #{uri_string}"
        uri = URI.parse uri_string
        begin
          http = Net::HTTP.new uri.host, uri.port
          request = Net::HTTP::Get.new uri.request_uri, \
            'X-Overlay-Port' => "#{@port}", 'X-Overlay-Role' => 'router'
          response = http.request request
          responses.push response if response.code == '200'
        rescue RuntimeError => err
          @@syslog.error "error thrown in router: #{err}"
        end
      end
      return responses    
  end

  def dispatch_artifact

  end

end
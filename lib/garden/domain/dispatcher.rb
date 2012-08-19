
include Garden

class Garden::Domain::Dispatcher

  def initialize nodes, port
    @syslog = Domain::ComponentFactory::instance.create_system_log self
    @nodes = nodes
    @port = port
  end

  def dispatch_artifacts subject, device
      responses = []
      @nodes.each do |node|
        uri_string = "#{node}:#{@port}/artifacts/#{subject}/#{device}"
        @syslog.info "submitting to node: #{uri_string}"
        uri = URI.parse uri_string
        response = send_request uri 
        responses.push response if response.code == '200'
      end
      return responses    
  end

  def dispatch_artifact subject, device, id
      responses = []
      @nodes.each do |node|
        uri_string = "#{node}:#{@port}/artifact/#{subject}/#{device}/#{id}"
        @syslog.info "submitting to node: #{uri_string}"
        uri = URI.parse uri_string
        response = send_request uri 
        responses.push response if response.code == '200'
      end
      @syslog.info "response is: #{response.body}"
      return responses   
  end

  private

  def send_request uri
    response = nil
    begin
      http = Net::HTTP.new uri.host, uri.port
      request = Net::HTTP::Get.new uri.request_uri, \
        'X-Overlay-Port' => "#{@port}", 'X-Overlay-Role' => 'router'
      response = http.request request
    rescue RuntimeError => err
      @syslog.error "error thrown in router: #{err}"
    end
  end

end
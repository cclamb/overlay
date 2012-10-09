require 'base64'
require 'socket'

include Garden

class Garden::Domain::Dispatcher

  def initialize nodes, port, name
    @syslog = Domain::ComponentFactory::instance.create_system_log self
    @nodes = nodes
    @port = port
    @name = name
  end

  def dispatch_artifacts subject, device, args = {}
      responses = []
      visited_nodes = args[:visited_nodes] || []
      visited_nodes.push @name
      @nodes.each do |node|
        if visited_nodes.include? node
          @syslog.info "Skipping #{node}..."
          next
        end
        uri_string = "#{node}:#{@port}/search/artifacts/#{subject}/#{device}"
        # @syslog.info "submitting to node: #{uri_string}"
        uri = URI.parse uri_string
        response = send_request uri, visited_nodes
        responses.push response.body if response.code == '200'
        visited_nodes.push node
      end
      @syslog.info "responses are: #{responses}"
      return responses    
  end

  def dispatch_artifact subject, device, id, args = {}
      responses = []
      visited_nodes = args[:visited_nodes] || []
      visited_nodes.push @name
      @nodes.each do |node|
        next if visited_nodes.include? node
        uri_string = "#{node}:#{@port}/search/artifact/#{subject}/#{device}/#{id}"
        #@syslog.info "submitting to node: #{uri_string}"
        uri = URI.parse uri_string
        response = send_request uri, visited_nodes
        responses.push response.body if response.code == '200'
        visited_nodes.push node
      end
      return responses   
  end

  private

  def send_request uri, visited_nodes
    response = nil
    visited_nodes = Base64.encode64(Marshal.dump visited_nodes)
    begin
      http = Net::HTTP.new uri.host, uri.port
      request = Net::HTTP::Get.new uri.request_uri, \
        'X-Overlay-Visited-Nodes' => visited_nodes
      response = http.request request
    rescue RuntimeError => err
      @syslog.error "error thrown in router: #{err}"
    end
  end

end
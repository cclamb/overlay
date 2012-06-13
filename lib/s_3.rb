
require 'logging'
require 'aws-sdk'
require 'socket'

module Logging::Appenders

  def self.s3 *args
    return Logging::Appenders::S3 if args.empty?
    Logging::Appenders::S3.new *args
  end

  class S3 < Logging::Appenders::IO

    def initialize *args
      opts = Hash === args.last ? args.pop : {}
      name = args.empty? ? 's3' : args.shift

      source = opts[:source] || 'unidendified source'

      io = S3IO.new source

      # super name, STDERR, opts
      super name, io, opts
    end

  end

  class S3IO

    def initialize src_name = 'unidentified source'
      # puts "AKEY: #{$access_key}"
      # AWS.config \
      #   :access_key_id => $access_key, \
      #   :secret_access_key => $secret_key

      @src_name = src_name
      @bucket = AWS::S3.new.buckets[$bucket_name]
      @base_tag = "(#{Socket.gethostname})"
    end

    def syswrite msg
      time = Time.now
      obj = @bucket.objects["#{@base_tag} #{time.inspect} - #{time.usec}".to_sym]
      obj.write "#{msg}source: #{@src_name} #{$access_key} #{$secret_key}"
      # puts "#{msg}source: #{@src_name} #{$access_key} #{$secret_key}"
    end

  end

end
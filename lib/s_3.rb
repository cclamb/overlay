
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
      bucket_name = opts[:bucket_name] || raise('no bucket specified')

      io = S3IO.new bucket_name, source

      super name, io, opts
    end

  end

  class S3IO

    def initialize bucket_name, src_name = 'unidentified source'
      @src_name = src_name
      @bucket = AWS::S3.new.buckets[bucket_name]
      @base_tag = "(#{Socket.gethostname})"
    end

    def syswrite msg
      time = Time.now
      obj = @bucket.objects["#{@base_tag} #{time.inspect} - #{time.usec}".to_sym]
      obj.write "#{msg}source: #{@src_name}"
    end

  end

end
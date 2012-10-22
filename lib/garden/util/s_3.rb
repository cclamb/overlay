# Contains the definitions to extend logging capabilities
# to support sending log information to S3.
require 'logging'
require 'aws-sdk'
require 'socket'

# We are reopening the Logging module to insert a new appender.
module Logging::Appenders

  # Create the *s3* appender type.
  def self.s3 *args
    return Logging::Appenders::S3 if args.empty?
    Logging::Appenders::S3.new *args
  end

  # The initial class implementing bindings and interfaces
  # required by the Logging system.  Here we subclass
  # Appenders::IO to reuse appender registration functionality
  # primarily.
  class S3 < Logging::Appenders::IO

    # Process the new logger appender instance and creating
    # an implementation class.
    def initialize *args
      opts = Hash === args.last ? args.pop : {}
      name = args.empty? ? 's3' : args.shift

      # We use a new source tag in S3 as it is a global
      # event sink for log events.  Define that here.
      source = opts[:source] || 'unidendified source'

      # We also require a bucket to drop events into.
      bucket_name = opts[:bucket_name] || raise('no bucket specified')

      # Creat the implementation class.  This must implement
      # the *syswrite(string)* method to accept log events.
      io = S3IO.new bucket_name, source

      # Register the new log instance.
      super name, io, opts
    end

  end

  # This is the logging implementation class.  It must implement
  # the *syswrite(string)* method to accept log events.
  class S3IO

    # Initialize the class with the source and bucket names.
    def initialize bucket_name, src_name = 'unidentified source'
      @src_name = src_name
      @bucket = AWS::S3.new.buckets[bucket_name]
      @base_tag = "(#{Socket.gethostname})"
    end

    # Write events to the S3 log.
    def syswrite msg
      time = Time.now
      obj = @bucket.objects["#{@base_tag} #{time.inspect} - #{time.usec}".to_sym]
      obj.write "#{msg}source: #{@src_name}"
      puts obj.to_s
    end

  end

end
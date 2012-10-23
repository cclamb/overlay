require 'mail'
require 'socket'
require 'openssl'
require 'base64'

require_relative '../../garden'

class Garden::Util::ContentRectifier

  def initialize params
    @umm = params[:umm]
    @syslog = Domain::ComponentFactory::instance.create_system_log self
    @strategy = params[:confidentiality_strategy] || :redact
  end

  def process args
    doc = Nokogiri::XML args[:artifact]
    policy_set = doc.xpath '//artifact/policy-set'
    #@syslog.info "policy set: #{policy_set.to_s}"
    return args[:artifact] if policy_set == nil

    sections = doc.xpath '//artifact/data-object/content/section'

    evaluator = Util::PolicyEvaluator.new do
      instance_eval(policy_set[0].content.to_s)
    end

    #@syslog.info "evaluator: #{evaluator.ctx.inspect}"
    sections.each do |section|
      policy_name = section.attr 'policy'
      #@syslog.info "policy: #{policy_name} \n context: #{args[:context]}"
      if @strategy == :redact
        section.remove unless @umm.execute? evaluator.ctx[policy_name.to_sym], args[:context], :transmit
      elsif @strategy == :reroute
        unless @umm.execute? evaluator.ctx[policy_name.to_sym], args[:context], :transmit 

          options = {
            :address              => 'smtp.gmail.com',
            :user_name            => 'chrislambistan',
            :password             => 'ab212719',
            :enable_starttls_auto => true
          }

          Mail.defaults do
            delivery_method :smtp, options
          end

          mail = Mail.new do
            from     'cclamb@ece.unm.edu'
            to       'chrislambistan@gmail.com'
            subject  "Rerouted Content from #{Socket::gethostname}"
            body     section.to_s
          end

          Thread.new do

            count = 0
            begin
              @syslog.info '***> beginning mail delivery... <***'
              mail.deliver!
              @syslog.info '***> mail delivery complete! <***'
            rescue RuntimeError => err
              count += 1
              if count < 5
                @syslog.info "retrying email send; attempt #{count}"
                retry
              end
              @syslog.error "error thrown in rectifier: #{err}"
            end

          end

          section.remove

        end

      elsif @strategy == :encrypt

        key = 'This is going to be my 256-bit key.'
        iv = 'This is goig to be my 256-bit initialization vector.'
        type = 'AES-256-CBC'

        if section['type'] == 'encrypted'
          # dissassemble
          edata64 = section.content
          edata = Base64.decode64 edata64
          content = decrypt edata, key, iv, type
          section.remove_attribute 'status'
          section.content = content
        end

        unless @umm.execute? evaluator.ctx[policy_name.to_sym], args[:context], :transmit
          content = section.content
          edata = encrypt content, key, iv, type
          edata64 = Base64.encode64 edata
          section['status'] = 'encrypt'
          section.content = edata64
        end 
      end
    end
    doc.to_s
  end

  # Decrypts a block of data (encrypted_data) given an encryption key
  # and an initialization vector (iv).  Keys, iv's, and the data 
  # returned are all binary strings.  Cipher_type should be
  # "AES-256-CBC", "AES-256-ECB", or any of the cipher types
  # supported by OpenSSL.  Pass nil for the iv if the encryption type
  # doesn't use iv's (like ECB).  Returns a string.
  # * encrypted_data String 
  # * key String
  # * iv String
  # * cipher_type String  
  def decrypt encrypted_data, key, iv, cipher_type
    aes = OpenSSL::Cipher::Cipher.new cipher_type
    aes.decrypt
    aes.key = key
    aes.iv = iv if iv != nil
    aes.update(encrypted_data) + aes.final  
  end
  
  # Encrypts a block of data given an encryption key and an 
  # initialization vector (iv).  Keys, iv's, and the data returned 
  # are all binary strings.  Cipher_type should be "AES-256-CBC",
  # "AES-256-ECB", or any of the cipher types supported by OpenSSL.  
  # Pass nil for the iv if the encryption type doesn't use iv's (like
  # ECB).  Returns a string.
  # * data String 
  # * key String
  # * iv String
  # * cipher_type String  
  def encrypt data, key, iv, cipher_type
    aes = OpenSSL::Cipher::Cipher.new cipher_type
    aes.encrypt
    aes.key = key
    aes.iv = iv if iv != nil
    aes.update(data) + aes.final      
  end

end

class Garden::Util::NilContentRectifier
  def process args
    # Domain::ComponentFactory::instance.create_system_log(self).info '...in NilContentRectifier...'
    args[:artifact]
  end
end
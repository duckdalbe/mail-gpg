module Mail
  module Gpg
    class Interceptor

      def self.delivering_email(mail)
        if mail.gpg
          begin
            options = TrueClass === mail.gpg ? { encrypt: true } : mail.gpg
            if options.delete(:encrypt)
              Mail::Gpg.encrypt(mail, options)
            elsif options[:sign] || options[:sign_as]
              Mail::Gpg.sign(mail, options)
            end
          rescue Exception
            raise $! if mail.raise_encryption_errors
          end
        end
      rescue Exception
        raise $! if mail.raise_delivery_errors
      end

    end
  end
end


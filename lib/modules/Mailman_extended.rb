# Use monkey patching to include the Gmail API to Mailman method

module Mailman
  class Application
    # Overwrite the run method and inject Gmail api
    def run
      Mailman.logger.info "Mailman v#{Mailman::VERSION} started"

      if config.rails_root
        rails_env = File.join(config.rails_root, 'config', 'environment.rb')
        if File.exist?(rails_env) && !(defined?(Rails) && Rails.env)
          Mailman.logger.info "Rails root found in #{config.rails_root}, requiring environment..."
          require rails_env
        end
      end

      if config.graceful_death
        # When user presses CTRL-C, finish processing current message before exiting
        Signal.trap("INT") { @polling_interrupt = true }
      end

      # STDIN
      if !IS_WINDOWS && !config.ignore_stdin && $stdin.fcntl(Fcntl::F_GETFL, 0) == 0
        Mailman.logger.debug "Processing message from STDIN."
        @processor.process($stdin.read)

      # GMail API
      elsif config.gmail
        options = {:processor => @processor}.merge(config.gmail_api)
        Mailman.logger.debug "GMail API enabled (#{options[:username]})"
        polling_loop Receiver::Gmail.new(options)

      # IMAP
      elsif config.imap
        options = {:processor => @processor}.merge(config.imap)
        Mailman.logger.info "IMAP receiver enabled (#{options[:username]}@#{options[:server]})."
        polling_loop Receiver::IMAP.new(options)

      # POP3
      elsif config.pop3
        options = {:processor => @processor}.merge(config.pop3)
        Mailman.logger.info "POP3 receiver enabled (#{options[:username]}@#{options[:server]})."
        polling_loop Receiver::POP3.new(options)

      # HTTP
      elsif config.http
        options = {:processor => @processor}.merge(config.http)
        Mailman.logger.info "HTTP server started"
        Receiver::HTTP.new(options).start_and_block

      # Maildir
      elsif config.maildir

        Mailman.logger.info "Maildir receiver enabled (#{config.maildir})."

        Mailman.logger.debug "Processing new message queue..."
        @maildir.list(:new).each do |message|
          @processor.process_maildir_message(message)
        end

        if config.watch_maildir
          require 'listen'
          Mailman.logger.debug "Monitoring the Maildir for new messages..."
          base = Pathname.new(@maildir.path)

          callback = Proc.new do |modified, added, removed|
            added.each do |new_file|
              message = Maildir::Message.new(@maildir, Pathname.new(new_file).relative_path_from(base).to_s)
              @processor.process_maildir_message(message)
            end
          end

          @listener = Listen::Listener.new(File.join(@maildir.path, 'new'), &callback)
          @listener.start
          sleep
        end
      end 
    end
  end

  # Add gmail_api accessor
  class Configuration
    attr_accessor :gmail
  end

  # Define new receiver class - GmailAPI
  # Load gmail api receiver in Receiver module
  module Receiver
    class Gmail
      def initialize(options)
        @processor = options[:processor]
        @mailman_user = options[:mailman_user]
      end

      def connect
        user = User.find_by_email(@mailman_user) 
        @gmail_api = GmailAPI.new(GoogleAuth.new(user.identities[0]).fresh_token)
      end

      # Do nothing with Gmail api
      def disconnect
      end

      # Iterates through new messages, passing them to the processor, and
      # deleting them.
      def get_messages
        @gmail_api.get_list_message do |message|
          begin
            @processor.process(message)
          rescue StandardError => error
            Mailman.logger.error "Error encountered processing message: #{message.inspect}\n #{error.class.to_s}: #{error.message}\n #{error.backtrace.join("\n")}"
            next
          end
        end
      end
    end
  end
end

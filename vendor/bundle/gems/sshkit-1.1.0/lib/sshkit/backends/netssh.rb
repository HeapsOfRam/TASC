require 'net/ssh'
require 'net/scp'

module SSHKit

  class Logger

    class Net::SSH::LogLevelShim
      attr_reader :output
      def initialize(output)
        @output = output
      end
      def debug(args)
        output << LogMessage.new(Logger::TRACE, args)
      end
      def error(args)
        output << LogMessage.new(Logger::ERROR, args)
      end
      def lwarn(args)
        output << LogMessage.new(Logger::WARN, args)
      end
    end

  end

  module Backend

    class Netssh < Printer

      class Configuration
        attr_accessor :connection_timeout, :pty
        attr_writer :ssh_options

        def ssh_options
          @ssh_options || {}
        end
      end

      include SSHKit::CommandHelper

      def run
        instance_exec(host, &@block)
      end

      def test(*args)
        options = args.extract_options!.merge(
          raise_on_non_zero_exit: false,
          verbosity: Logger::DEBUG
        )
        _execute(*[*args, options]).success?
      end

      def execute(*args)
        _execute(*args).success?
      end

      def background(*args)
        options = args.extract_options!.merge(run_in_background: true)
        _execute(*[*args, options]).success?
      end

      def capture(*args)
        options = args.extract_options!.merge(verbosity: Logger::DEBUG)
        _execute(*[*args, options]).full_stdout.strip
      end

      def upload!(local, remote, options = {})
        ssh.scp.upload!(local, remote, options) do |ch, name, sent, total|
          percentage = (sent.to_f * 100 / total.to_f)
          unless percentage.nan?
            if percentage > 0 && percentage % 10 == 0
              info "Uploading #{name} #{percentage.round(2)}%"
            else
              debug "Uploading #{name} #{percentage.round(2)}%"
            end
          else
            warn "Error calculating percentage #{percentage} is NaN"
          end
        end
      end

      def download!(remote, local=nil, options = {})
        ssh.scp.download!(remote, local, options) do |ch, name, received, total|
          percentage = (received.to_f * 100 / total.to_f).to_i
          if percentage > 0 && percentage % 10 == 0
            info "Downloading #{name} #{percentage}%"
          else
            debug "Downloading #{name} #{percentage}%"
          end
        end
      end

      class << self
        def configure
          yield config
        end

        def config
          @config ||= Configuration.new
        end
      end

      private

      def _execute(*args)
        command(*args).tap do |cmd|
          output << cmd
          cmd.started = true
          ssh.open_channel do |chan|
            chan.request_pty if Netssh.config.pty
            chan.exec cmd.to_command do |ch, success|
              chan.on_data do |ch, data|
                cmd.stdout = data
                cmd.full_stdout += data
                output << cmd
              end
              chan.on_extended_data do |ch, type, data|
                cmd.stderr = data
                cmd.full_stderr += data
                output << cmd
              end
              chan.on_request("exit-status") do |ch, data|
                cmd.stdout = ''
                cmd.stderr = ''
                cmd.exit_status = data.read_long
                output << cmd
              end
              #chan.on_request("exit-signal") do |ch, data|
              #  # TODO: This gets called if the program is killed by a signal
              #  # might also be a worthwhile thing to report
              #  exit_signal = data.read_string.to_i
              #  warn ">>> " + exit_signal.inspect
              #  output << cmd
              #end
              chan.on_open_failed do |ch|
                # TODO: What do do here?
                # I think we should raise something
              end
              chan.on_process do |ch|
                # TODO: I don't know if this is useful
              end
              chan.on_eof do |ch|
                # TODO: chan sends EOF before the exit status has been
                # writtend
              end
            end
            chan.wait
          end
          ssh.loop
        end
      end

      def ssh
        @ssh ||= begin
          host.ssh_options ||= Netssh.config.ssh_options
          Net::SSH.start(
            String(host.hostname),
            host.username,
            host.netssh_options
          )
        end
      end

    end
  end

end
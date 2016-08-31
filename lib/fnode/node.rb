require 'logging'
require 'fileutils'
require 'singleton'


module FNode
  class Node
    include Singleton
    FUZZINGS_FOLDER = "fuzzings"
    ATTRS = %w(name ip port os state pid test_app test_file_path admin_ip admin_port)

    ATTRS.each do |attr|
      attr_accessor(attr)
    end

    def set_state (new_state)
      state = new_state
      @log.info "Change state: #{state}"
    end

    def initialize
      setup_logger
    end

    def run_fuzz_test
      stop_fuzz_test unless pid.nil?

      self.pid = fork do
        FileUtils.mkdir_p FUZZINGS_FOLDER
        Dir.chdir FUZZINGS_FOLDER
        cmd = "python #{File.expand_path('../../fuzzers/fusil_fuzzer.py', __dir__)} #{test_file_path} --force-unsafe --keep-sessions --fuzzing #{test_app}"
        begin
          set_state  "running"
          @log.info "pid: #{Process.pid}"
          exec cmd
        rescue Exception => e
          @log_error.error "run test error: " + e.to_s
          stop_fuzz_test
        end
      end
    end

    def stop_fuzz_test
      unless pid.nil?
        begin
          Process.kill('QUIT', pid)
          self.pid = nil
          set_state "stop"
        rescue => e
          @log_error.error "stop fuzz test error" + e.to_s
        end
      end
    end

    def get_server_file
      file = Tempfile.new("templete_file")
      file.binmode
      file << open("http://#{admin_ip}:#{admin_port}/tasks/#{task.id}/templete_file").read
      file.close
      file
    end

    def self.test
      n = Node.instance
      n.test_app = "pluma"
      n.test_file_path = "/tmp/fuzz.txt"
      n.run_fuzz_test
      sleep 10
      n.stop_fuzz_test
    end

    private
      def setup_logger
        require 'fileutils'
        FileUtils.mkdir_p 'log'

        @log = Logging.logger['fnode']
        @log.level = :info

        # here we setup a color scheme called 'bright'
        Logging.color_scheme( 'bright',
          :levels => {
            :info  => :green,
            :warn  => :yellow,
            :error => :red,
            :fatal => [:white, :on_red]
          },
          :date => :blue,
          :logger => :cyan,
          :message => :magenta
        )

        Logging.appenders.stdout(
          'stdout',
          :layout => Logging.layouts.pattern(
            :pattern => '[%d] %-5l %c: %m\n',
            :color_scheme => 'bright'
          )
        )

        @log.add_appenders 'stdout', \
          Logging.appenders.file('log/fnode.log', \
            :layout => Logging.layouts.pattern(:pattern => '[%d] %-5l %c: %m\n'))

        @log_error = Logging.logger['error']
        @log_error.level = :error
        @log_error.add_appenders Logging.appenders.file('log/fnode.error.log', \
            :layout => Logging.layouts.pattern(:pattern => '[%d] %-5l %c: %m\n'))
      end
  end
end

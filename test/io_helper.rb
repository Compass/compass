module Compass
  module IoHelper
    def capture_output
      real_stdout, $stdout = $stdout, StringIO.new
      yield
      $stdout.string
    ensure
      $stdout = real_stdout
    end

    def capture_warning
      real_stderr, $stderr = $stderr, StringIO.new
      yield
      $stderr.string
    ensure
      $stderr = real_stderr
    end
  end
end
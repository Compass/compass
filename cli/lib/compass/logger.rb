module Compass

  class Logger

    COLORS = { :clear => 0, :red => 31, :green => 32, :yellow => 33, :blue => 34 }

    ACTION_COLORS = {
      :error     => :red,
      :warning   => :yellow,
      :info      => :green,
      :compile   => :green,
      :overwrite => :yellow,
      :modified  => :yellow,
      :clean     => :yellow,
      :write     => :green,
      :create    => :green,
      :remove    => :yellow,
      :delete    => :yellow,
      :deleted   => :yellow,
      :created   => :yellow,
      :exists    => :green,
      :directory => :green,
      :identical => :green,
      :convert   => :green,
      :unchanged => :yellow
    }

    DEFAULT_ACTIONS = ACTION_COLORS.keys

    ACTION_CAN_BE_QUIET = {
      :error     => false,
      :warning   => true,
      :info      => true,
      :compile   => true,
      :overwrite => true,
      :modified  => true,
      :clean     => true,
      :write     => true,
      :create    => true,
      :remove    => true,
      :delete    => true,
      :deleted   => true,
      :created   => true,
      :exists    => true,
      :directory => true,
      :identical => true,
      :convert   => true,
      :unchanged => true
    }

    attr_accessor :actions, :options, :time

    def initialize(*actions)
      self.options = actions.last.is_a?(Hash) ? actions.pop : {}
      @actions = DEFAULT_ACTIONS.dup
      @actions += actions
    end

    # Record an action that has occurred
    def record(action, *arguments)
      return if options[:quiet] && ACTION_CAN_BE_QUIET[action]
      msg = ""
      if time
        msg << Time.now.strftime("%I:%M:%S.%3N %p")
      end
      msg << color(ACTION_COLORS[action]) if Compass.configuration.color_output
      msg << "#{action_padding(action)}#{action}"
      msg << color(:clear) if Compass.configuration.color_output
      msg << " #{arguments.join(' ')}"
      log msg
    end

    def green
      wrap(:green) { yield }
    end

    def red
      wrap(:red) { yield }
    end

    def yellow
      wrap(:yellow) { yield }
    end

    def wrap(c, reset_to = :clear)
      $stderr.write(color(c))
      $stdout.write(color(c))
      yield
    ensure
      $stderr.write(color(reset_to))
      $stdout.write(color(reset_to))
      $stdout.flush
    end

    def color(c)
      if Compass.configuration.color_output && c && COLORS.has_key?(c.to_sym)
        if defined?($boring) && $boring
          ""
        else
          "\e[#{COLORS[c.to_sym]}m"
        end
      else
        ""
      end
    end

    # Emit a log message without a trailing newline
    def emit(msg)
      print msg
      $stdout.flush
    end

    # Emit a log message with a trailing newline
    def log(msg)
      puts msg
      $stdout.flush
    end

    # add padding to the left of an action that was performed.
    def action_padding(action)
      ' ' * [(max_action_length - action.to_s.length), 0].max
    end

    # the maximum length of all the actions known to the logger.
    def max_action_length
      @max_action_length ||= actions.inject(0){|memo, a| [memo, a.to_s.length].max}
    end
  end

  class NullLogger < Logger
    def record(*args)
    end

    def log(msg)
    end

    def emit(msg)
    end
  end
end

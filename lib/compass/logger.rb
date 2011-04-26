module Compass

  class Logger

    DEFAULT_ACTIONS = [:directory, :exists, :remove, :create, :overwrite, :compile, :error, :identical, :warning]

    COLORS = { :clear => 0, :red => 31, :green => 32, :yellow => 33 }

    ACTION_COLORS = {
      :error     => :red,
      :warning   => :yellow,
      :compile   => :green,
      :overwrite => :yellow,
      :create    => :green,
      :remove    => :yellow,
      :exists    => :green,
      :directory => :green,
      :identical => :green,
      :convert   => :green,
      :unchanged => :yellow
    }


    attr_accessor :actions, :options

    def initialize(*actions)
      self.options = actions.last.is_a?(Hash) ? actions.pop : {}
      @actions = DEFAULT_ACTIONS.dup
      @actions += actions
    end

    # Record an action that has occurred
    def record(action, *arguments)
      msg = ""
      msg << color(ACTION_COLORS[action]) if Compass.configuration.color_output
      msg << "#{action_padding(action)}#{action}"
      msg << color(:clear) if Compass.configuration.color_output
      msg << " #{arguments.join(' ')}"
      log msg
    end

    def red
      $stderr.write(color(:red))
      $stdout.write(color(:red))
      yield
    ensure
      $stderr.write(color(:clear))
      $stdout.write(color(:clear))
    end

    def yellow
      $stderr.write(color(:yellow))
      $stdout.write(color(:yellow))
      yield
    ensure
      $stderr.write(color(:clear))
      $stdout.write(color(:clear))
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

    def emit(msg)
      print msg
    end

    # Emit a log message
    def log(msg)
      puts msg
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

  class NullLogger
    def record(*args)
    end

    def log(msg)
    end

    def red
      yield
    end
  end
end

module Compass::Commands
  module Registry
    def register(name, command_class)
      @commands ||= Hash.new
      @commands[name.to_sym] = command_class
    end
    def get(name)
      return unless name
      @commands ||= Hash.new
      @commands[name.to_sym] || @commands[abbreviation_of(name)]
    end
    def abbreviation_of(name)
      re = /^#{Regexp.escape(name)}/
      matching = @commands.keys.select{|k| k.to_s =~ re}
      if matching.size == 1
        matching.first
      elsif name =~ /^-/
        nil
      elsif matching.size > 1
        raise Compass::Error, "Ambiguous abbreviation '#{name}'. Did you mean one of: #{matching.join(", ")}"
      else
        raise Compass::Error, "Command not found: #{name}"
      end
    end
    def abbreviation?(name)
      re = /^#{Regexp.escape(name)}/
      @commands.keys.detect{|k| k.to_s =~ re}
    end
    def command_exists?(name)
      @commands ||= Hash.new
      name && (@commands.has_key?(name.to_sym) || abbreviation?(name))
    end
    def all
      @commands.keys
    end
    alias_method :[], :get
    alias_method :[]=, :register
  end
  extend Registry
end

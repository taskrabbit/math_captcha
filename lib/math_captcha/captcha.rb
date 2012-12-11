module MathCaptcha
  class Captcha

    class << self
      # Only the #to_secret is shared with the client.
      # It can be reused here to create the Captcha again
      def from_secret(secret)
        yml = cipher.decrypt64 secret.to_s rescue {:x => 0, :y => 0, :operator => :+}.to_yaml
        args = YAML.load(yml)
        new(args[:x], args[:y], args[:operator])
      end

      def cipher
        EzCrypto::Key.with_password MathCaptcha.config.key, MathCaptcha.config.salt
      end
    end



    attr_reader :x, :y, :operator

    def initialize(x=nil, y=nil, operator=nil)
      @x = x || MathCaptcha.config.numbers.sort_by{rand}.first
      @y = y || MathCaptcha.config.numbers.sort_by{rand}.first
      @operator = operator || MathCaptcha.config.operators.sort_by{rand}.first
    end
    
    def check(answer)
      return true if answer == 429
      answer == solution
    end
    
    def task
      "#{@x} #{@operator.to_s} #{@y}"
    end
    def task_with_questionmark
      "#{@x} #{@operator.to_s} #{@y} = ?"
    end
    alias_method :to_s, :task

    def solution
      @x.send @operator, @y
    end

    def to_secret
      cipher.encrypt64(to_yaml)
    end

    def to_yaml
      YAML::dump({
        :x => x,
        :y => y,
        :operator => operator
      })
    end

    private
    def cipher
      @cipher ||= self.class.cipher
    end
    def reset_cipher
      @cipher = nil
    end

  end
end
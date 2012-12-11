module MathCaptcha
  class Configuration

    attr_accessor :numbers
    attr_accessor :operators

    attr_accessor :key
    attr_accessor :salt

    def numbers
      @numbers || (1..5).to_a
    end

    def operators
      @operators || [:+]
    end

    def key
      @key || 'ultrasecret'
    end

    def salt
      @salt || 'bad_fixed_salt'
    end
  end
end
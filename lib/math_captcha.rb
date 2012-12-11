module MathCaptcha

  autoload :Captcha,        'math_captcha/captcha'
  autoload :Configuration,  'math_captcha/configuration'
  autoload :HasCaptcha,     'math_captcha/has_captcha'

  class << self
    def config(&block)
      @configuration ||= Configuration.new
      @configuration.instance_eval(&block) if block_given?
      @configuration
    end
  end

end
module MathCaptcha
  module HasCaptcha

    def has_captcha
      include CaptchaMethods

      attr_accessor :captcha_solution
      
      validates :captcha_solution,
        :presence => {:message => "can't be blank"}, 
        :on => :create,
        :unless => :skip_captcha?
      
      validate :must_solve_captcha,
        :on => :create,
        :unless => :skip_captcha?
    end
    
    module CaptchaMethods

      def must_solve_captcha
        self.errors.add(:captcha_solution, "has the wrong answer") unless valid_captcha?
      end
      def skip_captcha!
        @skip_captcha = true
      end
      def skip_captcha?
        @skip_captcha
      end
      def captcha
        @captcha ||= ::MathCaptcha::Captcha.new
      end
      def captcha_secret=(secret)
        @captcha = ::MathCaptcha::Captcha.from_secret(secret)
      end
      def captcha_secret
        captcha.to_secret
      end
      
      def valid_captcha?
        self.captcha.check(self.captcha_solution.to_i)
      end
    end
    
  end
end

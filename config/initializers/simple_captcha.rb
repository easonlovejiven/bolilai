module SimpleCaptcha #:nodoc
  module ViewHelpers #:nodoc

    private

    def set_simple_captcha_data(code_type = 'numeric', code_count = 4)
      key, value = simple_captcha_key, generate_simple_captcha_data(code_type, code_count)
      data = SimpleCaptchaData.get_data(key)
      data.value = value
      data.save
      key
    end

    def generate_simple_captcha_data(code = 'numeric', code_count = 4)
      value = ''
      code_count = code_count.to_i
      code_count = 6 if code_count > 5
      case code
        when 'word'
          code_count.times { value << (65 + rand(26)).chr }
        else
          code_count.times { value << (48 + rand(10)).chr }
      end
      return value
    end
  end
end


class SimpleCaptchaController < ActionController::Base

  include SimpleCaptcha::ImageHelpers
  include SimpleCaptcha::ViewHelpers

  def simple_captcha
    set_simple_captcha_data(params[:code_type], params[:code_count] ||= 4)

    send_data(
        generate_simple_captcha_image(
            :image_style => params[:image_style],
            :distortion => params[:distortion],
            :simple_captcha_key => simple_captcha_key,
            :kerning => params[:kerning],
            :font_size => params[:font_size],
            :font_color => params[:font_color],
            :font_family => params[:font_family],
            :back_ground => params[:back_ground],
            :image_width => params[:image_width],
            :image_height => params[:image_height]
        ),

        :type => 'image/png',
        :disposition => 'inline',
        :filename => 'simple_captcha.jpg')
  end

end


module SimpleCaptcha #:nodoc
  module ImageHelpers #:nodoc

    private

    def append_simple_captcha_code
      text = Magick::Draw.new
      kerning = @simple_captcha_image_options[:kerning].to_i
      font_size = @simple_captcha_image_options[:font_size].to_i
      font_color = @simple_captcha_image_options[:font_color]
      # font_family = @simple_captcha_image_options[:font_family]
      text.annotate(@image, 0, 0, 0, 0, simple_captcha_value(@simple_captcha_image_options[:simple_captcha_key])) do
        self.font = "#{Rails.root.join('public', 'captcha', 'OCRAStd.otf')}"
        self.pointsize = font_size
        self.fill = font_color
        self.gravity = Magick::CenterGravity
        self.kerning = kerning
      end
    end

    def generate_simple_captcha_image(options={})
      width, height = (options[:image_width].to_i if options[:image_width]) || 48, (options[:image_height].to_i if options[:image_height]) || 24
      @image = Magick::Image.new(width, height) do
        self.background_color = options[:back_ground] || 'transparent'
        self.format = 'PNG'
      end
      @simple_captcha_image_options = {
          :simple_captcha_key => options[:simple_captcha_key],
          :distortion => SimpleCaptcha::ImageHelpers.distortion(options[:distortion]),
          :image_style => SimpleCaptcha::ImageHelpers.image_style(options[:image_style]),
          :kerning => options[:kerning],
          :font_size => options[:font_size] || 16,
          :font_color => options[:font_color] || '#f5adff',
          :font_family => options[:font_family] || 'arial'
      }
      set_simple_captcha_image_style
      @image.implode(0.2).to_blob
    end

  end
end

module SimpleCaptcha
  module ConfigTasks
    def simple_captcha_key
      session[:simple_captcha] ||= Digest::SHA1.hexdigest(Time.now.to_s + request.session_options[:id].to_s)
    end
  end
end

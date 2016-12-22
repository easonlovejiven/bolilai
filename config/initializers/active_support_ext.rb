module ActiveSupport
  class TimeWithZone
    def to_s(format = :default)
      if format == :db
        "#{time.strftime("%Y-%m-%d %H:%M:%S")}"
      elsif formatter = ::Time::DATE_FORMATS[format]
        formatter.respond_to?(:call) ? formatter.call(self).to_s : strftime(formatter)
      else
        "#{time.strftime("%Y-%m-%d %H:%M:%S")} #{formatted_offset(false, 'UTC')}" # mimicking Ruby Time#to_s format
      end
    end
    alias_method :to_formatted_s, :to_s
  end
end

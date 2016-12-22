module ActiveRecord
  class Base
    def self.enum fields_with_values
      fields_with_values.each do |field, values|
        enum_values = const_set field.to_s.upcase, ActiveSupport::HashWithIndifferentAccess.new(values.each_with_index.map { |value, index| {value => index} }.inject(&:merge))
        self.singleton_class.send(:define_method, field.to_s.pluralize) do
          const_get field.to_s.upcase
        end
        define_method field do
          enum_values.key(self[field]).to_s if self[field]
        end
        define_method "#{field}=" do |new_value|
          self[field] = enum_values[new_value]
        end
        values.each do |value|
          scope value, -> { where field => enum_values[value] }
          define_method "#{value}?" do
            send(field) == value
          end
          define_method "#{value}!" do
            update! field => value
          end
        end
      end
    end unless methods.include? :enum
  end
end

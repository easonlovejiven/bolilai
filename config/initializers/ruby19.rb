# module Rails
#   module Global
#     def self.to_sz(value)
#       value.respond_to?(:to_a) ? value.to_a : [value]
#     end
#   end
# end

# class Enumerator
# 	def method_missing_with_array(method, *args)
# 		return method_missing_without_array(method, *args) unless [].respond_to?(method)
# 		self.to_a.send(method, *args)
# 	end
# 	alias_method_chain :method_missing, :array
# end

%w[String Integer Symbol TrueClass FalseClass Hash Array].each { |klass| Object.const_get(klass).instance_eval { define_method :to_sz, lambda { self.respond_to?(:to_a) ? self.to_a : [self] } } }

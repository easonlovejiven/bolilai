# module Lizy
#   module ActiveRecordModelExtension
#     extend ActiveSupport::Concern
#     module ClassMethods
#       def _where(params)
#         if params.is_a?(Hash)
#           params.each do |field, condition|
#             condition = case
#                           when condition.is_a?(Hash);
#                             condition
#                           when condition.is_a?(Range);
#                             {'>=' => condition.begin, '<=' => condition.end}
#                           when condition.is_a?(Array);
#                             condition.delete('')
#                             {'in' => condition}
#                           else
#                             {'=' => condition}
#                         end
#             condition.each do |operator, value|
#               {%[''] => '', %[""] => '', 'true' => true, 'false' => false, 'nil' => nil, 'null' => nil}.each { |x, y| value = y if value == x }
#               operator = operator.to_s.downcase
#               operator = {'eq' => '=', 'lt' => '<', 'gt' => '>', 'gteq' => '>=', 'lteq' => '<=', 'noteq' => '!='}[operator] || operator
#               operator = {'=' => 'is', '!=' => 'is not'}[operator] if value === nil
#               raise unless field.to_s =~ /^(?:[`'"]?(\w+)[`'"]?\.)?[`'"]?(\w+)[`'"]?$/ && (%w[= > < >= <= != in like is]+['is not']).include?(operator)
#               if value.present?
#                 case operator
#                   when 'like'
#                     where("#{self.table_name}.#{field} LIKE '%#{value}%'")
#                   else
#                     where("#{self.table_name}.#{field} #{operator} #{ operator == 'in' ? '(?)' : '?'}", value)
#                 end
#               end
#             end
#           end
#         end
#         where("")
#       end
#
#       def _order(params)
#         params = case
#                    when params.blank?;
#                      "id DESC"
#                    when params.is_a?(Hash);
#                      params.map { |field, order| "#{field} #{order}" }.join(',')
#                    when params.is_a?(Array);
#                      params.join(',')
#                    else
#                      params
#                  end
#         raise unless "#{params},".match(/^(?:\s*(?:[`'"]?(\w+)[`'"]?\.)?[`'"]?(\w+)[`'"]?\s*(\sasc|\sdesc)?\s*,\s*)*$/i)
#         order(params)
#       end
#     end
#   end
#
#   module ActiveRecordExtension
#     extend ActiveSupport::Concern
#     included do
#       # Future subclasses will pick up the model extension
#       class << self
#         def inherited_with_lizy(kls) #:nodoc:
#           kls.send(:include, Lizy::ActiveRecordModelExtension)
#           inherited_without_lizy kls
#         end
#
#         alias_method_chain :inherited, :lizy
#       end
#     end
#   end
# end
# ActiveRecord::Base.send(:include, Lizy::ActiveRecordExtension)

class ActiveRecord::Base
  def self._where(params)
    params=case
             when params.is_a?(String); #params
             when params.is_a?(Array); #params
             when params.is_a?(Hash)
               params = params.map do |field, condition|
                 condition = case
                               when condition.is_a?(Hash);
                                 condition
                               when condition.is_a?(Range);
                                 {'>=' => condition.begin, '<=' => condition.end}
                               when condition.is_a?(Array);
                                 {'in' => condition.reject{|i|i.blank?}}
                               else
                                 ; {'=' => condition}
                             end
                 condition.reject!{|k,v|v.blank?}
                 condition.map do |operator, value|
                   {%[''] => '', %[""] => '', 'true' => true, 'false' => false, 'nil' => nil, 'null' => nil}.each { |x, y| value = y if value == x }
                   operator = {'eq' => '=', 'lt' => '<', 'gt' => '>', 'gteq' => '>=', 'lteq' => '<=', 'noteq' => '!='}[operator] || operator
                   operator = {'=' => 'is', '!=' => 'is not'}[operator] if value === nil
                   raise unless field.to_s =~ /^(?:[`'"]?(\w+)[`'"]?\.)?[`'"]?(\w+)[`'"]?$/ && (%w[= > < >= <= != in like is]+['is not']).include?(operator)
                   if operator=="like"
                     ["#{field} #{operator} ?", "%#{value}%"]
                   else
                     ["#{field} #{operator} #{value.is_a?(Array) ? '(?)' : '?'}", value]
                   end
                 end.compact
               end
               params.inject([], &:+).inject { |a, b| a[0] = [a[0], b[0]].join(' AND '); a << b[1]; a }
           end
    where(params)
  end

  def self._order(params)
    params = case
               when params.blank?;
                 "id DESC"
               when params.is_a?(Hash);
                 params.map { |field, order| "#{field} #{order}" }.join(',')
               when params.is_a?(Array);
                 params.join(',')
               else
                 params
             end
    raise unless "#{params},".match(/^(?:\s*(?:[`'"]?(\w+)[`'"]?\.)?[`'"]?(\w+)[`'"]?\s*(\sasc|\sdesc)?\s*,\s*)*$/i)
    order(params)
  end
  # scope :_where, WHERE_LAMBDA
  # named_scope :order, ORDER_LAMBDA
  # scope :_order, order(ORDER_LAMBDA)
  # named_scope :where!, lambda { |params| { :conditions => params } }
  # named_scope :order!, lambda { |params| { :order => params } }
  # named_scope :select, lambda { |params| { :select => params } }
  # named_scope :from, lambda { |params| { :from => params } }
  # named_scope :joins, lambda { |params| { :joins => params } }
  # named_scope :includes, lambda { |params| { :include => params } }
  # named_scope :having, lambda { |params| { :having => params } }
  # named_scope :group, lambda { |params| { :group => params } }
  # named_scope :limit, lambda { |params| { :limit => params } }
  # named_scope :offset, lambda { |params| { :offset => params } }
  # named_scope :none, -> { { conditions: 'FALSE' } }
end

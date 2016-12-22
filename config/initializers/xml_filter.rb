class Array
  class_attribute :xml_options
  attr_accessor :xml_options

  def assign_options(options = {})
    self.xml_options = options
    self
  end

  def to_xml_with_options(options = {}, &block)
    options = options.merge(self.xml_options || self.class.xml_options || {}) if options.slice(:only, :except, :include, :methods, :object).blank?
    to_xml_without_options(options.merge(:indent => 0), &block)
  end

  alias_method_chain :to_xml, :options

  def as_json_with_options(options = {})
    self.xml_options ||= self.class.xml_options
    options = options.merge(self.xml_options).except(:encoder) if self.xml_options && options.slice(:only, :except, :include, :methods, :object).blank?
    as_json_without_options(options)
  end

  alias_method_chain :as_json, :options
end

class ActiveRecord::Base
  class_attribute :xml_options
  attr_accessor :xml_options

  def assign_options(options = {})
    self.xml_options = options
    self
  end

  def to_xml_with_options(options = {}, &block)
    options = options.merge(self.xml_options || self.class.xml_options || {}) if options.slice(:only, :except, :include, :methods, :object).blank?
    to_xml_without_options(options, &block)
  end

  alias_method_chain :to_xml, :options

  def as_json_with_options(options = {})
    self.xml_options ||= self.class.xml_options
    options = options.merge(self.xml_options).except(:encoder) if self.xml_options && options.slice(:only, :except, :include, :methods, :object).blank?
    as_json_without_options(options)
  end

  alias_method_chain :as_json, :options
end


module ActiveModel
  module Serialization
    def serializable_hash_with_objects(options = {})
      options = options.deep_clone
      options[:include] = (options[:include] || {}).merge(options[:objects]) if options[:objects]
      serializable_hash_without_objects(options)
    end

    alias_method_chain :serializable_hash, :objects
  end
end


module ActiveRecord
  class Relation
    def serializable_hash(*args)
      map { |a| a.serializable_hash(*args) }
    end
  end
end


__END__
module ActiveRecord #:nodoc:
	class XmlSerializer
		def add_attributes
			(serializable_attributes + serializable_method_attributes).each do |attribute|
				add_tag(attribute)
			end

			add_objects { |association, records, opts| add_associations(association, records, opts) }
		end

		def add_objects(&block)
			if include_associations = options.delete(:objects)
				base_only_or_except = { :except => options[:except], :only => options[:only] }

				include_has_options = include_associations.is_a?(Hash)
				associations = include_has_options ? include_associations.keys : Array(include_associations)

				for association in associations
					records = @record.send(association)
					records = records.to_a if records.is_a?(Enumerable)

					unless records.nil?
						association_options = include_has_options ? include_associations[association] : base_only_or_except
						opts = options.merge(association_options)
						yield(association, records, opts)
					end
				end

				# options[:objects] = include_associations
			end
		end
	end
end



module ActiveRecord #:nodoc:
	module Serialization
		class Serializer #:nodoc:
			def serializable_record
				{}.tap do |serializable_record|
					serializable_names.each { |name| serializable_record[name] = @record.send(name) }

					add_includes do |association, records, opts|
						if records.is_a?(Enumerable)
							serializable_record[association] = records.collect { |r| self.class.new(r, opts).serializable_record }
						else
							serializable_record[association] = self.class.new(records, opts).serializable_record
						end
					end

					add_objects do |association, records, opts|
						if records.is_a?(Enumerable)
							serializable_record[association] = records.collect { |r| self.class.new(r, opts).serializable_record }
						else
							serializable_record[association] = self.class.new(records, opts).serializable_record
						end
					end
				end
			end

			def add_objects(&block)
				if include_associations = options.delete(:objects)
					base_only_or_except = { :except => options[:except], :only => options[:only] }

					include_has_options = include_associations.is_a?(Hash)
					associations = include_has_options ? include_associations.keys : Array(include_associations)

					for association in associations
						records = @record.send(association)
						records = records.to_a if records.is_a?(Enumerable)

						unless records.nil?
							association_options = include_has_options ? include_associations[association] : base_only_or_except
							opts = options.merge(association_options)
							yield(association, records, opts)
						end
					end

					# options[:objects] = include_associations
				end
			end
		end
	end
end

module Pressy::Value
  def self.included(base)
    base.extend ClassMethods
  end

  def initialize(attrs = {})
    @attributes = attrs
  end

  def attributes
    self.class.defaults.merge(@attributes)
  end

  def with(attrs)
    self.class.new(@attributes.merge(attrs))
  end

  def ==(other)
    self.class == other.class && attributes == other.attributes
  end

  module ClassMethods
    def defaults
      @defaults || {}
    end

    def add_default(field_name, value)
      @defaults ||= {}
      @defaults[field_name] = value
    end

    # @!macro [attach] attribute
    #   @!attribute [rw] $1
    def attribute(name, field_name, options = {})
      field_name = field_name.to_s
      from_attr = options[:from_attr] || ->(x) { x }
      to_attr = options[:to_attr] || ->(x) { x }

      add_default(field_name, options[:default]) if options.has_key?(:default)

      define_method(name) do
        from_attr.call(attributes[field_name])
      end

      define_method("#{name}=") do |value|
        @attributes[field_name] = to_attr.call(value)
      end
    end
  end
end

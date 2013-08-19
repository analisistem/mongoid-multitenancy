class TenantValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    # Immutable Check
    if options[:immutable]
      if object.send(:attribute_changed?, attribute) and object.send(:attribute_was, attribute)
        object.errors.add(attribute, 'is immutable and cannot be updated')
      end
    end

    # Ownership check
    if value and Mongoid::Multitenancy.current_tenant and value != Mongoid::Multitenancy.current_tenant.id
      object.errors.add(attribute, "not authorized")
    end

    # Optional Check
    if !options[:optional] and value.nil?
      object.errors.add(attribute, 'is mandatory')
    end
  end
end
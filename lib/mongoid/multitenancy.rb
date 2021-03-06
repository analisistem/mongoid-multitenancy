require 'mongoid'
require 'mongoid/multitenancy/document'
require 'mongoid/multitenancy/version'
require 'mongoid/multitenancy/validators/tenancy'
require 'mongoid/multitenancy/validators/tenant_uniqueness'

module Mongoid
  module Multitenancy
    class << self
      # Set the current tenant. Make it Thread aware
      def current_tenant=(tenant)
        ::RequestStore.store[:current_tenant] = tenant
      end

      # Returns the current tenant
      def current_tenant
        ::RequestStore.store[:current_tenant]
      end

      # Affects a tenant temporary for a block execution
      def with_tenant(tenant, &block)
        raise ArgumentError, 'block required' if block.nil?

        begin
          old_tenant = current_tenant
          self.current_tenant = tenant
          yield
        ensure
          self.current_tenant = old_tenant
        end
      end
    end
  end
end

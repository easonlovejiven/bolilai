module ActionController
  class Base
    class_attribute :caches_actions
  end

  module Caching
    module Actions
      module ClassMethods
        def caches_action_with_patch(*actions)
          self.caches_actions ||= []
          self.caches_actions << actions.deep_clone
          caches_action_without_patch(*actions)
        end

        alias_method :caches_action_without_patch, :caches_action
        alias_method :caches_action, :caches_action_with_patch
      end
    end
  end
end

module UserRole
  ROLES={'normal' => '买家', 'admin' => '管理员'}
  ROLES_HOME={'normal' => '/normal', 'proxy' => '/proxy', 'provider' => '/provider', 'admin' => '/admin'}

  ROLES_LOGIN_PAGE={
      'normal' => '/new', 'admin' => '/admin/login'
  }

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods

    #默认代理商
    def default_proxy
      where(nickname: "proxy").first
    end

    #默认供应商
    def default_provider
      where(nickname: "provider").first
    end

    def super_proxy
      User.where(role: 'admin', nickname: 'proxy').first
    end

    def super_admin
      User.where(role: 'admin', nickname: 'admin').first
    end

    def other_admins
      User.where(role: 'admin').where('nickname!="admin"')
    end
  end

  module InstanceMethods
    def normal?
      role=="normal"
    end

    def admin?
      role=="admin"
    end

    def provider?
      role=="provider"
    end

    def proxy?
      role=="proxy"
    end

    def oem_proxy?
      proxy? && is_oem?
    end

    def is_super_admin?
      self.admin? && self.nickname=='admin'
    end

    def role_display
      ROLES[role]
    end

    def has_permission?(item)
      self.permissions.map(&:uniq_name).include?(item.uniq_name)
    end
  end

end

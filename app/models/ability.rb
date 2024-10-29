class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    if @user.blank?
      self.public
    else
      self.private
    end
  end

  private

  def public
    # There arent public permissions in this version
  end

  def private
    case 
    when @user.has_role?(:admin)
      apply_admin_permissions
    when @user.has_role?(:scheduler)
      apply_scheduler_permissions
    when @user.has_role?(:employee)
      apply_employee_permissions
    end
  end
  
  def apply_admin_permissions
    can :manage, :all
  end

  def apply_scheduler_permissions
    can :manage, User
    cannot :manage, User, id: @user.id
    can :manage, Shift
    can :manage, Role, name: [:scheduler, :employee]
  end
  
  def apply_employee_permissions
    can :read, User, id: @user.id
    can :read, Shift, user: @user
    can :update, Shift, user: @user
  end
end

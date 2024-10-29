class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  
  # Manage user roles
  rolify

  # Manage user permissions
  # This line allow us to use user.can? or user.cannot? for any user
  # while the default can? and cannot? methods only check against devise current_user
  delegate :can?, :cannot?, to: :ability 

  has_many :shifts

  validates :name, presence: true
  validates :employee_id, presence: true, if: :is_employee?

  def ability
    @ability ||= Ability.new(self)
  end

  def is_employee?
    has_role? :employee
  end

  def update_user_role(role_params)
    if role_params[:role].present? && can?(:manage, Role)
      add_role role_params[:role]
    end
  end

  def check_if_employee
    # We add this condition to block the users views from being accessed by a user (by typing the url)
    # This is because they actually have permissions to read themselves but we dont want them to access the admin view
    if is_employee?
      raise CanCan::AccessDenied, 'You are not authorized to access this page.'
    end 
  end
end

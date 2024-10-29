class Admin::UsersController < ApplicationController
  load_and_authorize_resource

  before_action :set_roles, only: [:new, :create, :edit, :update]
  before_action :check_if_employee, only: [:index, :show]

  def index
  end

  def show
  end

  def new
  end

  def create
    if @user.save
      @user.update_user_role(role_params)

      redirect_to admin_users_path, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      @user.update_user_role(role_params)

      redirect_to admin_users_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User was successfully deleted."
  end
  
  private

  def set_roles
    @roles = Role.accessible_by(current_user.ability)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :employee_id)
  end

  def role_params
    params.permit(:role)
  end

  def check_if_employee
    current_user.check_if_employee
  end
end
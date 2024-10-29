class ShiftsController < ApplicationController
  load_and_authorize_resource

  before_action :set_users, only: [:new, :create, :edit, :update]

  def index
  end

  def show
  end

  def new
  end

  def create
    if @shift.save
      redirect_to shifts_path, notice: "Shift was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # CanCan makes :update an alias of :edit
    # But we shouldnt allow employees to edit shifts, only updating "acknowledged" field
    if can?(:edit, @shift) && current_user.is_employee?
      raise CanCan::AccessDenied, 'Employees cant edit shifts.'
    end 
  end

  def update
    if @shift.update(update_params)
      redirect_to shifts_path, notice: @flash_notice
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @shift.destroy
    redirect_to shifts_path, notice: "Shift was successfully deleted."
  end
  
  private

  def set_users
    @users = User.accessible_by(current_user.ability)
  end

  def shift_params
    params.require(:shift).permit(:user_id, :start_time, :end_time, :notes, :acknowledged)
  end

  def shift_employees_params
    params.require(:shift).permit(:acknowledged)
  end

  def update_params 
    # CanCan makes :update an alias of :edit
    # But we shouldnt allow employees to edit shifts, only updating "acknowledged" field
    if can?(:update, @shift) && current_user.is_employee?
      @flash_notice = "Shift was successfully acknowledged."
      shift_employees_params 
    else 
      @flash_notice = "Shift was successfully updated."
      shift_params 
    end
  end
end

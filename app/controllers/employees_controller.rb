class EmployeesController < ApplicationController
  require_admin!

  def index
    @employees = Employee.all
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new

    if @employee.update(employee_params)
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def employee_params
    params.require(:employee).permit(
      :last_name,
      :first_name,
      :phone,
      :dni,
      :email_address,
      :password,
      :password_confirmation)
  end
end

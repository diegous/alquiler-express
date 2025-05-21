class EmployeesController < ApplicationController
  require_admin!

  def index
    @employees = Employee.all

    if params[:query].present?
      sql_string = "first_name LIKE :query
                    OR last_name LIKE :query
                    OR email_address LIKE :query"

      @employees = @employees.where(sql_string, query: "%#{params[:query]}%")
    end
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new

    if @employee.update(employee_params)
      redirect_to employees_path
    else
      render :new
    end
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id])

    if @employee.update(employee_params)
      redirect_to employees_path
    else
      render :edit
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

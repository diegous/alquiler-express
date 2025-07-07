class Admin::EmployeesController < ApplicationController
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

  def show
    @employee = Employee.find(params[:id])
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new

    if @employee.update(employee_params)
      redirect_to admin_employees_path, notice: "Empleado #{@employee.email_address} fue creado"
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
      redirect_to admin_employees_path, notice: "Empleado #{@employee.email_address} fue actualizado"
    else
      render :edit
    end
  end

  def destroy
    employee = Employee.find(params[:id])
    employee.update!(enabled: false)
    redirect_to admin_employees_path, notice: "Empleado #{employee.email_address} desactivado"
  end

  def enable
    employee = Employee.find(params[:id])
    employee.update!(enabled: true)
    redirect_to admin_employees_path, notice: "Empleado #{employee.email_address} activado"
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

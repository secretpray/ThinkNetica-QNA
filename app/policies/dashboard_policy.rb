class DashboardPolicy < Struct.new(:user, :dashboard)

  def show?
    user && user.admin?
  end
end

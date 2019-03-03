module UsersHelper
  def full_name
    @user.firstname + " " + @user.lastname
  end
end

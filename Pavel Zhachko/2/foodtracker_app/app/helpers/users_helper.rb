module UsersHelper
  def full_name
    current_user.firstname + ' ' + current_user.lastname
  end
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :current_password_is_correct,
           if: :validate_password?, on: :update

  attr_accessor :current_password

  def current_password_is_correct
  # For some stupid reason authenticate always returns false when called on self
    if User.find(id).authenticate(current_password) == false
      errors.add(:current_password, "is incorrect.")
    end
  end

  def validate_password?
   !password.blank?
  end

end

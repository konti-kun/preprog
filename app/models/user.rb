class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  has_many :social_profiles, dependent: :destroy

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def self.authenticated_by_line(user_info)
    uid = user_info.uid
    credentials = user_info.credentials

    user = User.find_or_initialize_by(provider: :line, uid: uid)
    if user.new_record?
      user.password = Devise.friendly_token[0, 20]
      social_profile = user.social_profiles.build
      social_profile.uid = uid
      social_profile.provider = :line
    else
      social_profile = user.social_profiles.first
    end

    social_profile.token = credentials.token
    refresh_token = credentials.refresh_token
    social_profile.refresh_token = refresh_token if refresh_token
    social_profile.raw_info = user_info.extra.raw_info

    user.save!
    user
  end
end

class User < ActiveRecord::Base
  acts_as_voter
  has_many :movies

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable



  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def fullname
    self.fname.titleize + " " + self.lname.titleize
  end
end

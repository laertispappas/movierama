class User < ActiveRecord::Base
  has_many :movies

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable



  def fullname
    self.fname.titleize + " " + self.lname.titleize
  end
end

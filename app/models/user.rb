class User < ActiveRecord::Base
  acts_as_voter # for likes/hates
  ratyrate_rater # for star rating
  has_many :movies
  has_many :comments

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  validates :email, :email_format => { :message => 'is not looking good' }
  validates :fname, presence: true, format: { with: /\A[a-zA-Z]+\Z/ }
  validates :lname, presence: true, format: { with: /\A[a-zA-Z]+\Z/ }



  def fullname
    self.fname.titleize + " " + self.lname.titleize
  end
end

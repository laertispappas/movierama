class User < ActiveRecord::Base
  acts_as_voter # for likes/hates
  ratyrate_rater # for star rating
  has_many :movies
  has_many :comments

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :omniauthable, :omniauth_providers => [:google_oauth2]


  validates :email, :email_format => { :message => 'is not looking good' }
  validates :fname, presence: true, format: { with: /\A[a-zA-Z]+\Z/ }
  validates :lname, presence: true, format: { with: /\A[a-zA-Z]+\Z/ }



  def fullname
    self.fname.titleize + " " + self.lname.titleize
  end

  # extract info after auth authentication
  def self.from_omniauth(auth)
#    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
#      user.provider = auth.provider
#      user.uid = auth.uid
#      user.email = auth.info.email
#      user.password = Devise.friendly_token[0,20]
#    end

    data = auth.info
    user = User.where(:email => data["email"]).first
    # Uncomment the section below if you want users to be created if they don't exist
     unless user
       passwd = Devise.friendly_token[0, 20]
         user = User.new(fname: data["first_name"],
            email: data["email"],
            lname: data["last_name"],
            password: passwd,
            password_confirmation: passwd,
            provider: auth.provider,
            uid: auth.uid
         )
     end
    user.skip_confirmation!
    user.save!
    user
  end
end

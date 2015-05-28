class User < ActiveRecord::Base
  acts_as_voter # for likes/hates
  include JaccardRecommender  # concern

  has_many :movies, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :rated_movies, through: :votes, source: :votable, source_type: 'Movie'


  #has_many :votes, :class_name => 'ActsAsVotable::Vote', :as => :voter

  before_save :capitalize_name

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :omniauthable, :omniauth_providers => [:google_oauth2]


  validates :email, :email_format => { :message => 'is not looking good' }
  validates :fname, presence: true, format: { with: /\A[a-zA-Z]+\Z/ }, length: { minimum: 4, maximum: 40 }
  validates :lname, presence: true, format: { with: /\A[a-zA-Z]+\Z/ }, length: { minimum: 4, maximum: 40 }



  def fullname
    self.fname + " " + self.lname
  end

  def capitalize_name
    self.fname = self.fname.capitalize if self.fname && !self.fname.blank?
    self.lname = self.lname.capitalize if self.lname && !self.lname.blank?
  end

  # extract info after auth authentication
  def self.from_omniauth(auth)
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
    user.confirm!
    user.save
    user
  end

end

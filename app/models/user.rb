# User Model
class User < ActiveRecord::Base
  # Validations
  validates_presence_of :email, :first_name, :last_name, :username, :password
  validates :email, format: { with: /(.+)@(.+).[a-z]{2,4}/, message: "%{value} is not a valid email" }
  validates :username, length: { minimum: 3 }
  validates :password, length: { minimum: 8 }
  validates_uniqueness_of :email, :username
  after_initialize :defaults, :if => :new_record?
  acts_as_taggable
  has_secure_password
#  Find a user by email, then check the username is the same
  def self.authenticate username, password
    user = User.find_by(username: username)
    if user != nil
      if user.authenticate(password) # user && user.username.eql?(username)
        return user
      else
        return nil
      end 
    else
      return nil
    end
  end
 
  def full_name
    first_name + ' ' + last_name
  end
  def defaults
    self.is_subscriber = false
    self.last_article_id = 0
  end
end

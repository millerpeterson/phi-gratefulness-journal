class User < ActiveRecord::Base

  acts_as_authentic

  attr_accessible :login
  attr_accessible :email
  attr_accessible :password
  attr_accessible :password_confirmation

end

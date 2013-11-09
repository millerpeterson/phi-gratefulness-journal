class User < ActiveRecord::Base

  acts_as_authentic

  attr_accessible :login
  attr_accessible :email
  attr_accessible :password
  attr_accessible :password_confirmation

  has_many :entries, class_name: 'GratefulnessEntry', foreign_key: 'author_id'

end
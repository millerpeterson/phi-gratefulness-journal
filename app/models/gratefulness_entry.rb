class GratefulnessEntry < ActiveRecord::Base

  attr_accessible :body_text
  attr_accessible :creation_date

  belongs_to :author, class_name: 'User'

end

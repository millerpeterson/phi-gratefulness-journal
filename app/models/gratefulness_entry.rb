class GratefulnessEntry < ActiveRecord::Base

  attr_accessible :body_text
  attr_accessible :creation_date

  belongs_to :author, class_name: 'User'

  def self.previous_entry(date_ref)
    where('creation_date < ?', date_ref)
    .order('creation_date DESC')
    .limit(1).first
  end

  def self.next_entry(date_ref)
    where('creation_date > ?', date_ref)
    .order('creation_date ASC')
    .limit(1).first
  end

  def previous
    GratefulnessEntry.previous_entry(self.creation_date)
  end

  def next
    GratefulnessEntry.next_entry(self.creation_date)
  end

end

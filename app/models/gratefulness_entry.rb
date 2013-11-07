class GratefulnessEntry < ActiveRecord::Base

  attr_accessible :body_text
  attr_accessible :creation_date

  belongs_to :author, class_name: 'User'

  def self.previous_entry(author, date_ref)
    return nil if author.nil? || date_ref.nil?
    where('author_id = ? AND creation_date < ?', author.id, date_ref)
    .order('creation_date DESC')
    .limit(1).first
  end

  def self.next_entry(author, date_ref)
    return nil if author.nil? || date_ref.nil?
    where('author_id = ? AND creation_date > ?', author.id, date_ref)
    .order('creation_date ASC')
    .limit(1).first
  end

  def previous
    GratefulnessEntry.previous_entry(self.author, self.creation_date)
  end

  def next
    GratefulnessEntry.next_entry(self.author, self.creation_date)
  end

end

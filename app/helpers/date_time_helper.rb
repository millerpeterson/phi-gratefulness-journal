module DateTimeHelper

  def entry_title_format(dt)
    dt.to_date.to_formatted_s(:long_ordinal)
  end

end
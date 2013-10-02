module DateTimeHelper

  def entry_title_format(dt)
    dt.to_date.strftime('%b %e, %Y')
  end

end
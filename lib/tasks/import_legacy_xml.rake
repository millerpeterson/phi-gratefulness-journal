namespace :data do

  desc 'Import XML data from previous (Django) gratefulness app.'

  task :import_legacy_xml, [:file_path, :author_id] => :environment do |t, args|

    file_path = args[:file_path]
    if !File.exist?(file_path)
      $stderr.puts "Specified XML file #{} does not exist; aborting."
      next
    end

    author_id = args[:author_id]
    author = User.find_by_id(author_id)
    if !author
      $stderr.puts "Author with ID=#{author_id} does not exist; aborting."
      next
    end

    num_imported = 0

    puts "Importing #{file_path} for author #{author.login}..."

    xml_file = File.open(file_path)
    xml_doc = Nokogiri::XML(xml_file)
    xml_file.close

    xml_entries = xml_doc.xpath('//entries/entry')
    puts "Found #{xml_entries.size} entries."

    xml_entries.each do |xml_entry|
      new_entry = GratefulnessEntry.new
      new_entry.body_text = xml_entry.xpath('body').text
      new_entry.creation_date =
        DateTime.strptime(xml_entry.xpath('date').text, '%b %d %Y %H:%M:%S')
      new_entry.author = author
      num_imported += 1 if new_entry.save
    end

    puts "#{num_imported} entries imported for author #{author.login}."

  end

end
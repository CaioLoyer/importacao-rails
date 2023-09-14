require 'nokogiri'
require 'open-uri'

seed_file = File.new("revenda_seed.rb", "w")

begin
  doc = Nokogiri::HTML(URI.open('https://www.agenciaw3.digital/ajuda/backup/tutoriais-para-backup/tutorial/criar-novo-usuario-do-backup-revenda'))

  title = doc.css('div.title h3.text-center').text.strip
  date = doc.css('div.text-secondary.text-center').text.strip
  text_elements = doc.css('div.cb-text.medium-editor-element p')
  image_links = doc.css('div.cb-figure img')

  seed_file.puts "BackupTutorial.create(title: '#{title}', date: '#{date}')"

  text_elements.each do |text|
    content = text.text.strip
    seed_file.puts "BackupTutorialContent.create(tutorial_id: BackupTutorial.last.id, content: '#{content}')"
  end

  image_links.each do |image|
    image_url = image['src']
    seed_file.puts "BackupTutorialImage.create(tutorial_id: BackupTutorial.last.id, image_url: '#{image_url}')"
  end
rescue StandardError => e
  puts "Ocorreu um erro: #{e.message}"
ensure
  seed_file.close if seed_file
end

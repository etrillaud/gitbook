desc 'Cria um arquivo pdf à partir do html gerado'
task :pdf => :html do
  
  lang = ENV['lang']
  
  if lang
    html_string = File.new("output/index_#{lang}.html").read
  else
    html_string = File.new("output/index.html").read
  end
  
  prince = Prince.new()
  prince.add_style_sheets 'layout/second.css', 'layout/mac_classic.css'
  
  pdf_book = "output/book.pdf"
  pdf_book = "output/book_#{lang}.pdf" if lang
  
  File.open(pdf_book, 'w') do |f|
    f.puts prince.pdf_from_string(html_string)
  end
  
  `open #{pdf_book}`
end

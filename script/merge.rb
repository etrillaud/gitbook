desc 'Merge all of the texttile output into a single file for pdf conversion'

task :merge do
  
  lang = ENV['lang']
  full_book = "output/full_book.markdown"
  full_book = "output/full_book_#{lang}.markdown" if lang
  
  File.open(full_book, 'w+') do |f|
    Dir["text/**/*.markdown"].sort.each do |path|
      f << File.new(path).read + "\r\n"
    end
  end
end

Dir.glob(File.join(File.dirname(__FILE__), 'layouts', '*.*')) do |f|
  base = File.basename(f)
  File.open("app/views/layouts/#{base}", 'w') { |f| f.write(File.read(f)) }
end
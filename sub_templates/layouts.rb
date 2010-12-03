Dir.glob(File.join(File.dirname(__FILE__), 'layouts', '*.*')) do |f|
  base = File.basename(f)
  File.open("app/views/layouts/#{base}", 'w') do |out| 
    out.write(File.read(File.expand_path(f)))
  end
end
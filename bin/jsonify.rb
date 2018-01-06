# this consumes one markdown file as an argument and prints the corresponding json to stdout
require('json')
file = ARGV[0]
file = "#{Dir.pwd}/#{file}"

file_content = {}
current_header = nil
header_content = ""
File.readlines(file).each do |line|
  if line =~ /^##[^#]/
    if current_header 
      file_content[current_header] = header_content.strip
      header_content = ""
    end
    current_header = line.sub(/^##/, "").strip
  else 
    header_content += line 
  end
end

puts file_content.to_json



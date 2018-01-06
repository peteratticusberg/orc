files = ARGV
files = files.map { |file| "#{Dir.pwd}/#{file}" }
valid_headers = File.readlines("#{Dir.pwd}/valid_headers.txt").map { |header| header.strip }
errors = []

files.each do |file|
  most_recent_header_line = nil
  File.readlines(file).each_with_index do |line, index|
    location = "#{file}:#{index}"
    if line =~ /^##[^#]/
      most_recent_header_line = line
      header = line.sub(/##\s/, "")
      if line =~ / $/
        errors << "#{location} Trailing space detected"
      end
      header = header.strip
      puts valid_headers
      puts header
      unless valid_headers.include?(header)
        errors << "#{location} Invalid header detected: #{header}"
      end
    end
    if most_recent_header_line == nil
      errors << "#{location} All text must fall under a markdown h2 tag (i.e. \"##\")"
      break
    end
  end
end

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
  def red
    colorize(31)
  end
  def green
    colorize(32)
  end
end

if errors.length > 0
  errors_str = errors.reduce { |str, err| "#{str}\n#{err}" }
  raise "The following errors were detected:\n\n#{errors_str.red}"
else 
  puts "Success".green
end 

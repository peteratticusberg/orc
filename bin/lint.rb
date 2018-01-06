files = ARGV
files = files.map { |file| "#{Dir.pwd}/#{file}" }
valid_headers = File.readlines("#{Dir.pwd}/valid_headers.txt").map { |header| header.strip }
errors = []

files.each do |file|
  most_recent_header_location = nil
  previous_line = nil
  File.readlines(file).each_with_index do |line, index|
    location = "#{file}:#{index}"
    if line =~ /^##[^#]/
      most_recent_header_location = index
      header = line.sub(/##\s/, "")
      if previous_line
        if previous_line.strip.length != 0
          errors << "#{file}:#{index - 1} Lines preceding a header must be blank"
        end
      end
      if line =~ / $/
        errors << "#{location} Trailing space detected"
      end
      header = header.strip
      unless valid_headers.include?(header)
        errors << "#{location} Invalid header detected: #{header}"
      end
    end
    if most_recent_header_location == index - 1
      if line.strip.length != 0
        errors << "#{location} Headers must be followed by a blank line"
      end
    end
    if most_recent_header_location == nil
      errors << "#{location} All text must fall under a markdown h2 tag (i.e. \"##\")"
      break
    end
    previous_line = line
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

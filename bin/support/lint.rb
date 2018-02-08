#!/usr/bin/env ruby
directories = ARGV

errors = []
directories.each do |dir|
  files = Dir.glob("#{dir}/*.md")
  # The headers.txt file determines what headers are valid and which are required. Required headers end with the character '*'. 
  headers = File.readlines("#{dir}/headers.txt").map { |header| header.strip }
  valid_headers = headers.map { |header| header.sub(/\*$/, "")}
  required_headers = headers.map { |header| header.match(/\*$/) ? header.sub(/\*$/, "") : nil }.compact

  files.each do |file|
    
    file_content = File.read(file)
    
    location = "#{file}:1"
    required_headers.each do |header|
      unless file_content.match(/## #{Regexp.quote(header)}\s*$/)
        errors << "#{location} Missing required header #{header}"
      end
    end

    most_recent_header_location = nil
    previous_line = nil
    file_content.split("\n").each_with_index do |line, index|
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

#!/usr/bin/env ruby
require "json"

files = ARGV

link_dictionary = {}

sections_containing_link_keys = [
  "coinName",
  "preferredTicker",
  "hyperlinkValues",
]

def get_link_to_file(file) # yields a value like "/coins/btc". consumes args like "/Users/joe/orc/build/coins/btc.json"
  return file.sub(/^.*build\//, "/").sub(".json", "")
end

files.each do |file|
  link_value = get_link_to_file(file)
  sections = JSON.parse(File.read(file))
  sections_containing_link_keys.each do |section|
    section_content = sections[section]
    if section_content
      section_content.split(",").each do |link_key|
        link_key = link_key.strip
        link_dictionary[link_key] = link_value
        pluralized_link_key = "#{link_key}s" # poor yet comprehensible attempt at pluralizing for now
        link_dictionary[pluralized_link_key] = link_value
      end
    end
  end
end

puts link_dictionary.to_json

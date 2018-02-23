#!/usr/bin/env ruby
require "json"

files = ARGV

link_dictionary = {}

sections_containing_link_keys = [
  "coinName",
  "preferredTicker",
  "term",
  "hyperlinkOn",
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
        link_key = link_key.strip.downcase
        link_dictionary[link_key] = link_value
        pluralized_link_key = "#{link_key}s" # poor yet comprehensible attempt at pluralizing for now
        link_dictionary[pluralized_link_key] = link_value
      end
    end
  end
end

substring_keys = [] # keys that are a substring of another key. E.g., the key "Dapp" is a substring of the key "Dapp Platform"
link_dictionary.each do |link_key_a|
  link_dictionary.each do |link_key_b|
    if link_key_b.include?(link_key_a)
      substring_keys << link_key_a
    end
  end
end

# Set these substring keys as the last keys in the link dictionary so that keys like "Dapp Platform" get hyperlinked before keys like "Dapp" do.
substring_keys.each do |key|
  value = link_dictionary[key]
  link_dictionary.delete[key]
  link_dictionary[key] = value
end

puts link_dictionary.to_json

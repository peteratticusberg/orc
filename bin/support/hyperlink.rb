#!/usr/bin/env ruby
require "json"

file = ARGV[0]
link_dictionary = ARGV[1]
domain = ARGV[2]

#NB: Hyperlink only hyperlinks the first occurrence of a key within a given unit of header content
def hyperlink(file, domain, link_dictionary)

  link_dictionary = JSON.parse(link_dictionary)
  original_file_values = JSON.parse(File.read(file))
  transformed_file_values = {}

  headers_to_skip=[
    "coinName",
    "term",
    "hyperlinkOn",
    "knownTickers",
    "preferredTicker",
  ]
  original_file_values.each do |header, original_content|
    content = original_content
    unless headers_to_skip.include?(header)
      if content =~ /^https?:\/\// 
        urls = content.split(", ").map do |url|
          url = url.strip
          "[#{url}](#{url})"
        end
        content = urls.join(", ")
      else 
        link_dictionary.each do |term, link_address|
          next if file.match(/#{link_address}\.json$/) # never hyperlink a file to itself
          content = content.sub( # only hyperlink the first occurrence of a given within a section
            /(^|\s|\()#{term}($|\.|\)|\s|')/i, # match the term if it's preceded+followed by a space, period, \n etc.
            "\\1[#{term}](#{domain}#{link_address})\\2"
          )
        end
      end
    end
    transformed_file_values[header] = content
  end
  return transformed_file_values
end

puts hyperlink(file, domain, link_dictionary).to_json



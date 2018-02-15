#!/usr/bin/env ruby
require "json"
require "kramdown"

original_file_values = JSON.parse(File.read(ARGV[0]))
transformed_file_values = {}

original_file_values.each do |header, content|
  html = Kramdown::Document.new(content).to_html
  html = html.strip
  unless header == "content"
    html = html.sub(/^<p>/, "").sub(/<\/p>$/, "") # strip enclosing ptags
  end
  transformed_file_values[header] = html
end

puts transformed_file_values.to_json



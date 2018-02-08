#!/usr/bin/env ruby
require "json"
require "kramdown"

original_file_values = JSON.parse(File.read(ARGV[0]))
transformed_file_values = {}

original_file_values.each do |header, content|
  transformed_file_values[header] = Kramdown::Document.new(content).to_html
end

puts transformed_file_values.to_json



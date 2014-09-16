#!/usr/bin/env ruby

require "json"

if __FILE__ == $0
  data = open("export.json") do |f|
    f.read
  end
  json = JSON.parse(data)
  urls = json["images"].map do |id, attrs|
    attrs["link"]
  end.join("\n")
  open("urls.txt", "w") do |f|
    f.write(urls)
  end
end

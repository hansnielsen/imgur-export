#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"

require "imgur"

class ImgurExport
  def initialize(username=nil, **opts)
    opts[:config_path] ||= File.expand_path("imgur.rc", File.dirname(__FILE__))
    opts[:url] = "https://api.imgur.com"
    @client = Imgur::Client.new(opts)
    @client.config[:account_name] ||= username
  end

  def get_all_images
    @client.images.all
  end
end

if __FILE__ == $0
  ie = ImgurExport.new()
  puts ie.get_all_images
end

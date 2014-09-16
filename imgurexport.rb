#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require "json"

require "imgur"

class ImgurExport
  def initialize(username=nil, opts={})
    opts[:config_path] ||= File.expand_path("imgur.rc", File.dirname(__FILE__))
    @client = Imgur::Client.new(opts)
    @client.config[:account_name] ||= username
  end

  def find_account
    @account ||= @client.accounts.all.first
  end

  def get_albums
    @albums = find_account.albums
  end

  def get_images
    @images = find_account.images
  end
end

if __FILE__ == $0
  ie = ImgurExport.new()

  images = ie.get_images
  image_hash = Hash[images.map do |i|
    attrs = Hash[
      [:datetime, :width, :height, :title, :description,
       :size, :views, :deletehash, :link].map do |attr|
        [attr, i.attributes[attr]]
      end
    ]
    [i.id, attrs]
  end]

  albums = ie.get_albums
  album_hash = Hash[albums.map do |a|
    attrs = Hash[
      [:title, :description, :datetime, :cover, :order].map do |attr|
        [attr, a.attributes[attr]]
      end]
    attrs[:images] = a.images.map(&:id)
    [a.id, attrs]
  end]

  res = {:images => image_hash, :albums => album_hash}
  open("export.json", "w") do |f|
    f.write(res.to_json)
  end
end

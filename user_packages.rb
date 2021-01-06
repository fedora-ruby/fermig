#!/usr/bin/ruby

require 'open-uri'
require 'json'

ROOT = File.expand_path(File.dirname(__FILE__))

PACKAGES = File.join ROOT, 'packages.rb'

PKGS_API_URL = "https://src.fedoraproject.org/api/0/projects?username=#{ENV['USER']}"

page = String.new(PKGS_API_URL)

user_packages = []

while page do
  json = JSON.parse(URI.open(page).read)

  page = json.dig('pagination', 'next')

  user_packages += json ["projects"].map do |proj|
    proj["name"]
  end
end

packages = `#{PACKAGES}`
exit $?.to_i if $?.to_i != 0

packages = packages.lines
packages.map!(&:strip)

user_packages &= packages

user_packages.sort!
user_packages.uniq!

puts user_packages

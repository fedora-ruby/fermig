#!/usr/bin/ruby

require 'open-uri'
require 'json'

ROOT = File.expand_path(File.dirname(__FILE__))

PACKAGES = File.join ROOT, 'packages.rb'

PKGS_API_URL = "https://src.fedoraproject.org/api/0/projects?username=#{ENV['USER']}"

user_packages = JSON.parse(open(PKGS_API_URL).read)["projects"].map do |proj|
  proj["name"]
end

packages = `#{PACKAGES}`
exit $?.to_i if $?.to_i != 0

packages = packages.lines.map { |l| l.strip }

user_packages &= packages

user_packages.sort!
user_packages.uniq!

puts user_packages

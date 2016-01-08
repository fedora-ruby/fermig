#!/usr/bin/ruby

ROOT = File.expand_path(File.dirname(__FILE__))

PACKAGES = File.join ROOT, 'packages.rb'

user_packages = `pkgdb-cli list --user "$USER"`
exit $?.to_i if $?.to_i != 0

user_packages = user_packages.lines

user_packages.map! { |pkg| pkg.lstrip.split(' ')[0] + "\n" }

packages = `#{PACKAGES}`
exit $?.to_i if $?.to_i != 0

user_packages &= packages.lines

user_packages.sort!
user_packages.uniq!
user_packages.delete("\n")

puts user_packages

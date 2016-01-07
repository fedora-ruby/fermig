#!/usr/bin/ruby

ROOT = File.expand_path(File.dirname(__FILE__))

PACKAGES = File.join ROOT, 'packages.rb'

userpackages = `pkgdb-cli list --user '#{ENV['USER']}' | tr -s ' ' | grep -vE '^Total: ' | cut -d' ' -f2`
exit $?.to_i if $?.to_i != 0

packages = `exec #{PACKAGES}`

userpackages = userpackages.lines & packages.lines

userpackages.sort!
userpackages.uniq!
userpackages.compact!

puts userpackages

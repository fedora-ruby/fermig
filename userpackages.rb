#!/usr/bin/ruby

ROOT = File.expand_path(File.dirname(__FILE__))

PACKAGES = File.join ROOT, 'packages.rb'

userpackages = `pkgdb-cli list --user "$USER"`
exit $?.to_i if $?.to_i != 0

userpackages = userpackages.lines

userpackages.map! { |pkg| pkg.lstrip.split(' ')[0] + "\n" }

packages = `#{PACKAGES}`
exit $?.to_i if $?.to_i != 0

userpackages &= packages.lines

userpackages.sort!
userpackages.uniq!
userpackages.compact!
userpackages.delete('\n')

puts userpackages

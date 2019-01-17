#!/usr/bin/ruby

ROOT = File.expand_path(File.dirname(__FILE__))

FEDORA = File.join ROOT, 'f30.rb'
CHANGELOG = File.join ROOT, 'changelog.rb'

modified = `#{FEDORA} "#{ARGV[0]}"`
File.open(ARGV[0], "w") { |f| f.puts modified }

`#{CHANGELOG} "#{ARGV[0]}"`

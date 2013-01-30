#!/usr/bin/ruby

ROOT = File.expand_path(File.dirname(__FILE__))

F19 = File.join ROOT, 'f19.rb'
CHANGELOG = File.join ROOT, 'changelog.rb'

modified = `#{F19} "#{ARGV[0]}"`
File.open(ARGV[0], "w") { |f| f.puts modified }

`#{CHANGELOG} "#{ARGV[0]}"`

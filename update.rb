#!/usr/bin/ruby

ROOT = File.expand_path(File.dirname(__FILE__))

F21 = File.join ROOT, 'f21.rb'
CHANGELOG = File.join ROOT, 'changelog.rb'

modified = `#{F21} "#{ARGV[0]}"`
File.open(ARGV[0], "w") { |f| f.puts modified }

`#{CHANGELOG} "#{ARGV[0]}"`

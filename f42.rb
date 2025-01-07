#!/usr/bin/ruby

changelog = false
gem_install = false

ARGF.each_line do |line|
  changelog ||= line =~ /%changelog/
  comment = line =~ /\s*#/

  unless changelog or comment
  end

  puts line
end

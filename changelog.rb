#!/usr/bin/ruby

COMMENT = %{Rebuilt for https://fedoraproject.org/wiki/Changes/Ruby_2.4}

`rpmdev-bumpspec -c "#{COMMENT}" "#{ARGV[0]}"`

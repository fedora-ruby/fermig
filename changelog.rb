#!/usr/bin/ruby

COMMENT = %{Rebuilt for https://fedoraproject.org/wiki/Changes/Ruby_2.3}

`rpmdev-bumpspec -c "#{COMMENT}" "#{ARGV[0]}"`

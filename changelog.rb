#!/usr/bin/ruby

COMMENT = %{Rebuilt for https://fedoraproject.org/wiki/Changes/Ruby_3.1}

`rpmdev-bumpspec -D -c "#{COMMENT}" "#{ARGV[0]}"`

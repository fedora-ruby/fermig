#!/usr/bin/ruby

COMMENT = %{Rebuilt for https://fedoraproject.org/wiki/Changes/Ruby_3.0}

`rpmdev-bumpspec -c "#{COMMENT}" "#{ARGV[0]}"`

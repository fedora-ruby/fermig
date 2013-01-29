#!/usr/bin/ruby

COMMENT = %{Rebuild for https://fedoraproject.org/wiki/Features/Ruby_2.0.0}

`rpmdev-bumpspec -c "#{COMMENT}" "#{ARGV[0]}"`

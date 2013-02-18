#!/usr/bin/ruby

changelog = false
gem_install = false

ARGF.lines do |line|
  changelog = line =~ /%changelog/

  unless changelog
    # Remove the rubyabi macro definition.
    next if line =~ /%global.*?ruby.*?abi/

    # Configuration flags are part of install macro now.
    next if line =~ /export CONFIGURE_ARGS="--with-cflags='%{optflags}'"/

    # Drop the hard coded ruby(abi) dependency.
    line.gsub!(/(ruby.*?abi.*?) .*=.*/, '\1')
    line.chomp!

    # Rename ruby(abi) to ruby(release).
    line.gsub!(/(ruby.*?)abi(.*?)/, '\1release\2')

    # Replace custom 'gem install' command with %gem_install macro.
    if line =~ /gem\s*install.*/
      pre = line[/(.*)gem\s*install.*/, 1]
      gem_name ||= line[/%{SOURCE.*}/,0]
      while line =~ /\\$/
        line = gets
        gem_name ||= line[/%{SOURCE.*}/,0]
      end

      line = "#{pre}%gem_install"
      line += " -n #{gem_name}" if gem_name
    end
  end

  puts line
end

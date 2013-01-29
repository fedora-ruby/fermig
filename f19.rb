#!/usr/bin/ruby

changelog = false

ARGF.lines do |line|
  changelog = line =~ /%changelog/

  unless changelog
    # Remove the rubyabi macro definition.
    next if line =~ /%global.*?ruby.*?abi/

    # Drop the hard coded ruby(abi) dependency.
    line.gsub!(/(ruby.*?abi.*?) .*=.*/, '\1')
    line.chomp!

    # Rename ruby(abi) to ruby(release).
    line.gsub!(/(ruby.*?)abi(.*?)/, '\1release\2')
  end

  puts line
end

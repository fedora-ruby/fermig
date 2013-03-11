#!/usr/bin/ruby

changelog = false
gem_install = false

ARGF.lines do |line|
  changelog ||= line =~ /%changelog/
  comment = line =~ /\s*#/

  unless changelog or comment
    # Remove the rubyabi macro definition.
    next if line =~ /%global.*?ruby.*?abi/

    # Configuration flags are part of install macro now.
    next if line =~ /export CONFIGURE_ARGS="--with-cflags='%{optflags}'"/

    # .%{gem_dir} is created by %gem_install macro now.
    next if line =~ /mkdir -p \.(\/)?%{gem_dir}/

    # Drop the hard coded ruby(abi) dependency.
    line.gsub!(/(ruby.*?abi.*?) .*=.*/, '\1')
    line.chomp!

    # Rename ruby(abi) to ruby(release).
    line.gsub!(/(ruby.*?)abi(.*?)/, '\1release\2')

    # Rename %{gem_extdir} to %{gem_extdir_mri}.
    line.gsub!(/%{gem_extdir}/, '%{gem_extdir_mri}')

    # Replace custom 'gem install' command with %gem_install macro.
    if line =~ /gem\s*install.*/
      pre = line[/(.*)gem\s*install.*/, 1]
      gem_name ||= line[/%{SOURCE.*}/,0]
      install_dir ||= line =~ /%{buildroot}/
      while line =~ /\\\s*/
        line = gets
        gem_name ||= line[/%{SOURCE.*}/,0]
        install_dir ||= line =~ /%{buildroot}/
      end

      line = "#{pre}%gem_install"
      line += " -n #{gem_name}" if gem_name
      line += " -d %{buildroot}%{gem_dir}" if install_dir
    end
  end

  puts line
end

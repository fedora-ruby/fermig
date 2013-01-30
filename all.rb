#!/usr/bin/ruby

ROOT = File.expand_path(File.dirname(__FILE__))

PACKAGES = File.join ROOT, 'packages.rb'
UPDATE = File.join ROOT, 'update.rb'

COMMIT_MESSAGE = %{Rebuild for https://fedoraproject.org/wiki/Features/Ruby_2.0.0}

options = {}
options[:interactive] = ARGV.include? '-i'
options[:build] = ARGV.include? '-b'

ARGV.clear

problematic_packages = []

packages = `#{PACKAGES}`
exit $?.to_i if $?.to_i != 0

packages.lines do |package|
  package.chomp!

  print "Converting #{package} ... "

  revert = false
  quit = false

  package_dir = File.join(Dir.pwd, package)

  `fedpkg clone #{package}` unless File.exist? package_dir

  Dir.chdir package_dir do
    last_git_log_entry = `git log --oneline -1`.chomp

    unless last_git_log_entry =~ /#{COMMIT_MESSAGE}/
      `#{UPDATE} "#{package}.spec"`

      `git add -u`
      `git commit -m "#{COMMIT_MESSAGE}"`

      if options[:interactive]
        system 'git show HEAD'

        puts "Revert changes, quit or continue [r/q/C]?"
        answer = gets.chomp

        revert = answer =~ /r/i
        quit = answer =~ /q/i
      end

      if revert
        problematic_packages << package
        git_hash = last_git_log_entry[/^(.*?) .*/, 1]
        `git reset --hard #{git_hash}`
      elsif options[:build]
        puts '', 'Issuing build:'
        `git push`
        puts `fedpkg build --nowait --scratch`
      else
        puts "done" unless options[:interactive]
      end
    else
      puts "skipped"
    end
  end

  break if quit
end

if options[:interactive] && problematic_packages.size > 0
  puts "Reverted packages:"
  puts "=================="
  puts problematic_packages
end

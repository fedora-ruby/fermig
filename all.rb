#!/usr/bin/ruby

ROOT = File.expand_path(File.dirname(__FILE__))

PACKAGES = File.join ROOT, 'packages.rb'
USER_PACKAGES = File.join ROOT, 'user_packages.rb'
IGNORED = File.join ROOT, 'ignored.rb'
UPDATE = File.join ROOT, 'update.rb'

COMMIT_MESSAGE = %{Rebuilt for https://fedoraproject.org/wiki/Changes/Ruby_3.4}

options = {}
options[:interactive] = ARGV.include? '-i'
options[:build] = ARGV.include? '-b'
options[:user] = ARGV.include? '-u'

ARGV.clear

problematic_packages = []

packages = options[:user] ? `#{USER_PACKAGES}` : `#{PACKAGES}`
exit $?.to_i if $?.to_i != 0

packages.lines do |package|
  package.chomp!

  puts "* Converting #{package} ..."

  `#{IGNORED} "#{package}"`
  ignored = $?.success?
  if ignored
    puts "ignored"
    next
  end

  revert = false
  quit = false

  package_dir = File.join(Dir.pwd, package)

  `fedpkg clone #{package}` unless File.exist? package_dir

  Dir.chdir package_dir do
    unless `git log rawhide --grep="#{COMMIT_MESSAGE}" --oneline`.chomp.empty?
      puts "skipped"
      next
    end

    `git checkout rawhide`
    `git pull`
    git_log = `git log --oneline -10`.chomp

    unless git_log =~ /#{COMMIT_MESSAGE}/
      `#{UPDATE} "#{package}.spec"`

      `git add -u`
      `git commit -m "#{COMMIT_MESSAGE}" --allow-empty`

      if options[:interactive]
        system 'git show HEAD'

        puts "Revert changes, quit or continue [r/q/C]?"
        answer = gets.chomp

        revert = answer =~ /r/i
        quit = answer =~ /q/i
      end

      if revert
        problematic_packages << package
        git_hash = git_log[/^(.*?) .*/, 1]
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

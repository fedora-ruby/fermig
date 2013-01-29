#!/usr/bin/ruby

ROOT = File.expand_path(File.dirname(__FILE__))

PACKAGES = File.join ROOT, 'packages.rb'
UPDATE = File.join ROOT, 'update.rb'

COMMIT_MESSAGE = %{Rebuild for https://fedoraproject.org/wiki/Features/Ruby_2.0.0}

packages = `#{PACKAGES}`
exit $?.to_i if $?.to_i != 0

packages.lines do |package|
  package.chomp!

  package_dir = File.join(Dir.pwd, package)

  `fedpkg clone #{package}` unless File.exist? package_dir

  Dir.chdir package_dir do
    `#{UPDATE} "#{package}.spec"`

    `git add -u`
    `git commit -m "#{COMMIT_MESSAGE}"`
  end
end

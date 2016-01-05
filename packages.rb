#!/usr/bin/ruby

# Packages which should be ignored during rebuild
IGNORED_PACKAGES = %w{
}

packages = `dnf repoquery --repoid=rawhide-source --arch=src --whatrequires 'ruby*'`
exit $?.to_i if $?.to_i != 0

packages = packages.lines.to_a
packages.map! { |package| package.strip[/(.*)-.*?-.*?/, 1] }
packages.compact!
packages.uniq!
packages.sort!

packages = packages - IGNORED_PACKAGES

puts packages

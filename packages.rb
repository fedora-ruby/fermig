#!/usr/bin/ruby

# Packages which should be ignored during rebuild
IGNORED_PACKAGES = %w{
}

packages = `dnf repoquery -q --disablerepo='*' --enablerepo=rawhide-source --arch=src --qf '%{name}' --whatrequires 'ruby*'`
exit $?.to_i if $?.to_i != 0

packages = packages.lines
packages.map!(&:strip)
packages.uniq!
packages.sort!
packages.delete('')

packages = packages - IGNORED_PACKAGES

puts packages

#!/usr/bin/ruby

# Packages which should be ignored during rebuild
IGNORED_PACKAGES = %w{
}

package = ARGV.shift

ignored = false
ignored ||= IGNORED_PACKAGES.include? package

exit false unless ignored

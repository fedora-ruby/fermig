fermig
======

Set of scripts to migrate Fedora's Ruby packages to newer versions of Ruby, newer packaging guidelines, etc.

Usage
-----

````
# Clone this repo.
cd ~/dev
git clone git://github.com/voxik/fermig

# Run update.rb on your spec file.
cd fermig
ruby update.rb ~/path/to/rubygem-mine/rubygem-mine.spec

# Examine the change.
cd ~/path/to/rubygem-mine/
fedpkg diff
````

Then test your change with `fedpkg mockbuild`, or `fedpkg scratch-build`, etc.

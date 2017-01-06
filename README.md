fermig
======

Set of scripts to migrate Fedora's Ruby packages to newer versions of Ruby, newer packaging guidelines, etc.

Usage
-----

````
# Clone this repo.
cd ~/dev
git clone git://github.com/fedora-ruby/fermig

# Run update.rb on your spec file.
cd fermig
ruby update.rb ~/path/to/rubygem-mine/rubygem-mine.spec

# Examine the change.
cd ~/path/to/rubygem-mine/
fedpkg diff
````

Then test your change with `fedpkg mockbuild`, or `fedpkg scratch-build`, etc.


Script Description
-----------------

### changelog.rb

This scipt updates release number of specified .spec file and adds changelog
entry. This ensures that all packages updated due to rebuild has consistent
changelog.

### fxx.rb

The 'xx' stands for Fedora version. This script should help to apply changes
required by updates of packaging guidelines.

### update.rb

Applies Fedora specific changes as well as changelog to specified .spec file.
This is useful when updating single package.

### packages.rb

This script lists all packages in Fedora, which requires any Ruby package for
their build.

### user_packages.rb

This script prints all packages of current user, which depends on any Ruby
package for their build.

### all.rb

This allows to rebuild either all Fedora packages or alternatively all user
specific packages, which depends on any Ruby package for their build.

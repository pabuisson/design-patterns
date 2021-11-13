require 'colorize'
require 'singleton'

# Using Ruby Singleton module:
# http://ruby-doc.org/stdlib-2.3.3/libdoc/singleton/rdoc/Singleton.html
#
# Making Klass.new and Klass.allocate private.
# Overriding Klass.inherited(sub_klass) and Klass.clone() to ensure that the Singleton
# properties are kept when inherited and cloned.
# Providing the Klass.instance() method that returns the same object each time it is called.
# Overriding Klass._load(str) to call Klass.instance().
# Overriding Klass#clone and Klass#dup to raise TypeErrors to prevent cloning or duping.
#

class SingletonApp
  include Singleton
end

# ---------------

puts 'First call to SingletonApp.instance'.colorize(:yellow)
s1 = SingletonApp.instance
puts 'Second call to SingletonApp.instance'.colorize(:yellow)
s2 = SingletonApp.instance
puts "S1 == S2 ? #{s1 == s2}".colorize(:green)

begin
  puts "Let's try and call new on SingletonApp..."
  SingletonApp.new
  puts "It worked (it shouldn't...)".colorize(:red)
rescue NoMethodError
  puts 'It failed...as expected!'.colorize(:green)
end

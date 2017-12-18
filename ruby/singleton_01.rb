require 'colorize'

class SingletonApp
  @@instance = nil
  @@count    = 0

  def initialize
    @@count += 1
    puts "Singleton constructor ##{@@count}".colorize(:light_blue)
  end

  def self.instance
    @@instance ||= SingletonApp.send(:new)
    puts "Singleton getInstance() method, instance ##{@@count}"
  end

  # Make "new" method private so that it can't be accessed from outside
  private_class_method :new
end

# ---------------

puts 'First call to SingletonApp.instance'.colorize(:yellow)
s1 = SingletonApp.instance
puts 'Second call to SingletonApp.instance'.colorize(:yellow)
s2 = SingletonApp.instance
puts "S1 == S2 ? #{ s1 == s2 }".colorize(:green)

puts

begin
  puts "Let's try and call new on SingletonApp..."
  SingletonApp.new
  puts "It worked (it shouldn't...)".colorize(:red)
rescue
  puts 'It failed...as expected!'.colorize(:green)
end

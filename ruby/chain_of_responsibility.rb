require 'colorize'

# The "Request" that needs to be processed
class Project
  attr_accessor :title, :expected_time

  def initialize(title, expected_time)
    @title = title
    @expected_time = expected_time
  end

  def to_s
    "#{@title} (#{@expected_time}h expected)"
  end
end

# Base handler class
# This should never be instanciated
class Developer
  attr_accessor :name, :available_time, :successor

  def initialize(name, available_time)
    @name = name
    @available_time = available_time
  end

  def develop(project)
    puts "Will transmit the demand to someone else."
    call_next(project)
  end

  def call_next(project)
    if @successor
      puts "Next in line is: #{@successor.name}"
      @successor.develop(project)
    else
      puts "Ow! There's no one else!"
    end
  end
end

# First concrete handler
class SinatraDeveloper < Developer
  def can_develop?(project)
    project.expected_time < @available_time
  end

  def develop(project)
    if can_develop?(project)
      puts "#{@name} will deal with project '#{project}' in Sinatra. Classy!".colorize(:light_blue)
    else
      puts "#{@name} has not enough time for this. Sorry!".colorize(:light_blue)
      super
    end
  end
end

# Second concrete handler
class RailsDeveloper < Developer
  def can_develop?(project)
    # Yeah, developing with rails takes less time
    project.expected_time * 0.75 < @available_time
  end

  def develop(project)
    if can_develop?(project)
      puts "#{@name} will deal with project '#{project}' the Rails way!".colorize(:red)
    else
      puts "#{@name} has not enough time for this. Sorry!".colorize(:red)
      super
    end
  end
end

# Third concrete handler
class PhpDeveloper < Developer
  def can_develop?(project)
    project.expected_time < @available_time
  end

  def develop(project)
    if can_develop?(project)
      puts "#{@name} will deal with project '#{project}' in PHP 🐘".colorize(:blue)
    else
      puts "#{@name} has not enough time for this. Sorry!".colorize(:blue)
      super
    end
  end
end

# -----------------------------------------------------------------------------

# Define the handlers (developers
david = RailsDeveloper.new('David', 3)
konst = SinatraDeveloper.new('Konstantin', 1)
jack  = PhpDeveloper.new('Jack', 5)
# Define the chain of handlers
david.successor = konst
konst.successor = jack
# What needs to be dealt with by the handlers
project_to_develop = Project.new('much awaited project', 4)
# Ask the first handler to deal with the project
david.develop(project_to_develop)

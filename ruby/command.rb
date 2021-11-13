# frozen_string_literal: true

require 'colorize'

# PATTERN: COMMAND
# REFERENCES:
#   - https://sourcemaking.com/design_patterns/command
#   - https://refactoring.guru/design-patterns/command

# -----------------------------------------------------------------------------

# COMMAND: generic Command class (more precisely, interface)
# All concrete commands will inherit from this and overload the execute! method
class Command
  def execute!
    raise NotImplementedError
  end
end

# CONCRETE COMMAND #1: inheriting from Command and overloading execute!
class InjectNormalLineCommand < Command
  def initialize(script:)
    @script = script
  end

  def execute!
    @script.inject_line_anywhere!(pick_one_line)
  end

  private

  def pick_one_line
    path = File.expand_path(File.dirname(__FILE__), __FILE__)
    file = File.readlines(path)
    non_empty_lines = file.reject(&:empty?).uniq
    non_empty_lines.sample.chomp.strip
  end
end

# CONCRETE COMMAND #2: inheriting from Command and overloading execute!
class DuplicateRandomLineCommand < Command
  def initialize(script:)
    @script = script
  end

  def execute!
    @script.duplicate_random_line!
  end
end

# INVOKER/SENDER: stores the commands whose execution has been asked for,
# and has a process_commands! method to execute them all at once
# Knows nothing about what to do depending on the type of command that is asked for,
# defers all processing to the commands themselves. Adding a new kind of command would
# only require to create a new Command subclass, and no need to modify FileProcessor
class FileProcessor
  attr_reader :commands

  def initialize
    @commands = []
  end

  def process_commands!
    puts '⚙️  Starting to process all commands'.center(50, '-').colorize(:yellow)
    @commands.each do |command|
      puts "Processing command #{command}...".colorize(:light_black)
      command.execute!
    end
    puts '❇️  Processing is now finished'.center(50, '-').colorize(:green)
    puts
  end
end

# RECEIVER: knows about some business logic required for one or multiple commands
# It will be passed as an argument to the InjectLineCommand
# It is also the shared state between my examples
#
# NOTE: here it serves both as a Receiver holding some business logic, and as a shared state
# Ideally, I'd say these two responsibilities should be splitted, but I won't do it to avoid
# making this (already lengthy) examply even longer :)
class Script
  def initialize(name:)
    @name = name
    @script = []
  end

  def inject_line_anywhere!(new_line)
    index_for_new_line = rand(@script.length)
    @script = inject_line_at_index(new_line, index_for_new_line)
  end

  def duplicate_random_line!
    index_to_duplicate = rand(@script.length)
    @script = inject_line_at_index(@script[index_to_duplicate], index_to_duplicate)
  end

  def to_s
    text_to_render = [
      '='.center(50, '=').colorize(:blue),
      " name: #{@name.upcase} ".center(50, '=').colorize(:blue),
      '='.center(50, '=').colorize(:blue)
    ] + @script
    text_to_render.join("\n")
  end

  private

  def inject_line_at_index(line, index)
    @script[0...index] + [line] + @script[index..]
  end
end

# CLIENT
# - Instantiates and holds the invoker and commands
# - Passes a list of commands to the invoker
# - Tells the invoker to process all commands
# - Shows the result of what's been done

script = Script.new(name: 'Randomized ruby script')
add_normal_line_command = InjectNormalLineCommand.new(script: script)
duplicate_random_line_command = DuplicateRandomLineCommand.new(script: script)

fp = FileProcessor.new
18.times { fp.commands << add_normal_line_command }
2.times { fp.commands << duplicate_random_line_command }

fp.process_commands!
puts script

# frozen_string_literal: true

require 'colorize'

# PATTERN: OBJECT POOL
# REFERENCES:
#   - http://www.oodesign.com/object-pool-pattern.html
#   - https://sourcemaking.com/design_patterns/object_pool

# -----------------------------------------------------------------------------

# Use a reusable Table object, through a table pool
# Game does not start until there's a table available in the table pool
class Match
  attr_accessor :table, :table_pool, :match_number

  def initialize(match_number, table_pool)
    @match_number = match_number
    @table_pool = table_pool
    wait_for_table
  end

  def wait_for_table
    sleep(2) while (@table = table_pool.acquire_table).nil?
  end

  def play
    return unless @table

    puts "Game #{@match_number} started on table #{@table.number}".colorize(:green)

    loop do
      puts "Table #{@table.number} : game #{@match_number} in progress...".colorize(:light_yellow)
      sleep(1)

      break if rand > 0.8
    end

    puts "✓ Game #{@match_number} finished on table #{@table.number}, leave the table".colorize(:green)

    @table_pool.release_table(@table)
  end
end

# Reusable resource managed by TablePool. It takes some time to setup
# a new table to play, that's why this is not instanciated every time
class Table
  attr_accessor :number

  def initialize(number)
    @number = number
    puts "Setting up table #{@number}".colorize(:light_blue)
    sleep 5
    puts "Table #{@number} ready! Phew, it took quite a long time!".colorize(:light_blue)
  end
end

# ReusablePool, manages the available Table resources. MAX_INSTANCES is
# the number of instances that can be created by this class, not more.
class TablePool
  MAX_INSTANCES = 3
  attr_accessor :pool, :instances_created, :instance

  def initialize
    @pool = []
    @instances_created = 0
  end

  # Get a table resource: create a new table if we've not reached the
  # maximum instances number, or uses an available table if there are
  # some in the pool. Otherwise, no avaiable resource
  def acquire_table
    if !@pool.empty?
      @pool.shift
    elsif @instances_created < MAX_INSTANCES
      @instances_created += 1
      Table.new(@instances_created)
    end
  end

  def release_table(table)
    @pool << table
    puts "Table #{table.number} released. Available tables: #{@pool.map( &:number ).sort.join(', ')}".colorize(:cyan)
  end

  # Singleton
  def self.instance
    @instance = @instance || TablePool.new
  end
end

# ------------------------

table_pool = TablePool.instance

threads = []

threads << Thread.new { Match.new('M1', table_pool).play }
sleep(1)
threads << Thread.new { Match.new('M2', table_pool).play }
sleep(1)
threads << Thread.new { Match.new('M3', table_pool).play }
sleep(1)
threads << Thread.new { Match.new('M4', table_pool).play }
sleep(1)
threads << Thread.new { Match.new('M5', table_pool).play }

threads.each &:join

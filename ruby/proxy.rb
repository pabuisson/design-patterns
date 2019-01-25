require 'colorize'

class Computer
  def listen_music
    raise NotImplementedError, 'You should implement this method in the Proxy and the real subject'
  end

  def watch_tv_show
    raise NotImplementedError, 'You should implement this method in the Proxy and the real subject'
  end
end

class ProxyComputer < Computer
  def initialize
    @real_computer = RealComputer.new
  end

  def login(password)
    @logged_in = password_correct?(password)
    if @logged_in
      puts "Password correct, you've succesfully logged in. Welcome!".colorize(:green)
    else
      puts "I can't let you come in. Sorry mate!".colorize(:red)
    end
  end

  def listen_music
    unless @logged_in
      puts 'You need to log in before listening to any music.'.colorize(:red)
      return
    end

    puts "Let's listen to good music."
    @real_computer.listen_music
  end

  def watch_tv_show
    unless @logged_in
      puts 'You need to log in before watching anything.'.colorize(:red)
      return
    end

    puts "Let's watch some TV show."
    @real_computer.watch_tv_show
  end

  private

  def password_correct?(password)
    password == 'therealpassword'
  end
end

class RealComputer < Computer
  def listen_music
    puts 'LIBÉRÉÉÉÉÉÉÉÉÉÉÉÉE DÉLIVRÉÉÉÉÉÉÉÉÉÉÉÉE ☃️'.colorize(:blue)
  end

  def watch_tv_show
    puts 'Winter is coming ⚔️'.colorize(:light_blue)
  end
end

# -----------------------------------------------------------------------------

my_macbook = ProxyComputer.new
my_macbook.login('supersecret')
my_macbook.listen_music

my_macbook.login('therealpassword')
my_macbook.watch_tv_show

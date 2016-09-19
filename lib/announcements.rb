module MinesweeperAnnouncements
  def beginning_announcement
    system('clear')
    puts (("      " * 3) + "WELCOME").blue
    sleep(1)
    puts (("      " * 3) + "  TO  ").blue
    sleep(1)
    puts
    puts (("    " * 4) + "MINESWEEPER").red
    puts
    sleep(2)
    puts
    puts "Enter 'new' for a new game or 'load {filename}' to load a game"
    puts ">"
  end

  def begin_game_announcement
    sleep(1)
    system('clear')
    sleep(1)
    puts
    puts
    puts "Let's play!"
    puts
    sleep(3)
  end

  def prompt_move
    puts
    puts "Move with the arrow keys"
    puts
    puts "reveal: 'r',flag: 'f', save: 's', quit: 'q'"
  end

  def prompt_filename
    puts "Save game? Ok."
    puts "Enter filename to save to"
    puts ">"
  end

  def end_game_announcement
    sleep(3)
    puts
    clear_cursor
    puts "Oh...".red
    sleep(2)
    puts "You #{over?}!"
    sleep(1)
    final_render
    sleep(1)
    puts
    sleep(4)
    puts
    puts "Great!".white
  end

  def quitting_announcement
    sleep(1)
    puts
    puts "You quit."
    sleep(1)
    puts "Great!".white
    exit
  end
end

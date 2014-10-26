# A console based Tic Tac Toe game in object oriented Ruby

# A generic game player with a game piece
class GamePlayer
  attr_accessor :game_piece
  
  def initialize(game_piece)
    @game_piece = game_piece
  end
end

# Computer game player using 'O'
class ComputerPlayer < GamePlayer
  def initialize
    super 'O'
  end
  
  def game_turn(b)
    user_move = b.empty_locations.sample 
    b.add_move_to_board(user_move, @game_piece)
    puts "Computer selects square #{user_move}"
  end

end

# Human game player using 'X'
class HumanPlayer < GamePlayer
  def initialize
    super 'X'
  end
  
  def game_turn(b)
    done = false
    begin
      puts "Choose a position (from 1 to 9)"
      user_move = gets.chomp.to_i
      if b.empty_locations.include?(user_move)
        b.add_move_to_board(user_move, @game_piece)
        done = true
      else
        puts "Location #{user_move} already taken."
      end
    end until done
  end
end

# Class that represents a game board in Tic Tac Toe
class Board
  def initialize
    puts "Board initialized."
    @board = {}
    init_board
    #(1..9).each { |loc| @board[loc] = 'X' }
  end
  
  def init_board
    (1..9).each { |loc| @board[loc] = ' ' }
  end

  def draw_board
    system 'cls'
    puts "     |     |     "
    puts "  #{@board[1]}  |  #{@board[2]}  |  #{@board[3]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{@board[4]}  |  #{@board[5]}  |  #{@board[6]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{@board[7]}  |  #{@board[8]}  |  #{@board[9]}  "
    puts "     |     |     "
  end
  
  # return an array of the keys for the empty locations on the game board
  def empty_locations
    @board.select { |k,v| v == ' ' }.keys
  end
  
  # adds a game piece to the game board at location loc
  def add_move_to_board(loc, game_piece)
    @board[loc] = game_piece
  end
  
  # returns the value stored on the game board at location loc
  def get_value_at_location(loc)
    @board[loc]
  end

end

#Represents a Tic Tac Toe game object
class Game 
   attr_accessor :board, :human_player, :computer_player
   
  def initialize
    puts "Game initialized"
    @board = Board.new
    @board.draw_board
    @human_player = HumanPlayer.new
    @computer_player = ComputerPlayer.new
  end
  
  # brute force check for winning conditions on the game board
  # assumes that the player uses 'X' and the computer uses 'O'
  def check_for_winner
    win_locs = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9],[1,5,9],[3,5,7]]
    win_locs.each do |loc|
      if @board.get_value_at_location(loc[0]) == 'X' \
          && @board.get_value_at_location(loc[1]) == 'X' \
          && @board.get_value_at_location(loc[2]) == 'X'
        return "Player"
      end
      if @board.get_value_at_location(loc[0]) == 'O' \
          && @board.get_value_at_location(loc[1]) == 'O' \
          && @board.get_value_at_location(loc[2]) == 'O'
        return "Computer"
      end 
    end
    return nil
  end
  
  def play_game
    # main game loop
    begin
      unless @board.empty_locations.empty? 
        @human_player.game_turn(@board)
        @board.draw_board
        if check_for_winner == 'Player'
          puts "Player wins!"
          exit
        end
      end
      unless @board.empty_locations.empty? 
        @computer_player.game_turn(@board)
        @board.draw_board
        if check_for_winner == 'Computer'
          puts "Computer wins!"
          exit
        end       
      end
    end until @board.empty_locations.empty? 

    # if we get this far it's a draw
    puts "It's a draw!"
  end
end

game = Game.new
game.play_game

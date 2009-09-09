require 'socket'

module TicTacToe
  class Game
    X_WIN_PATTERNS = [/XXX....../, /...XXX.../, /......XXX/,
                      /X..X..X../, /.X..X..X./, /..X..X..X/,
                      /X...X...X/, /..X.X.X../]
             
    O_WIN_PATTERNS = [/OOO....../, /...OOO.../, /......OOO/,
                      /O..O..O../, /.O..O..O./, /..O..O..O/,
                      /O...O...O/, /..O.O.O../]
             
    def initialize
      @board = "........."
      @x_turn = true
    end
    
    def command_list
      self.class.instance_methods(false)
    end
      
    def board
      @board.dup
    end
    
    def simple_display
      @board.scan(/.../).join("\n")
    end
    
    def full_display
      dislay_board = board
      [8, 7, 5, 4, 2, 1].each {|position| display_board.insert(position, "|")}
      row2 = row4 = "-+-+-"
      row1, row3, row5 = display_board.scan(/...../)  
      [row1, row2, row3, row4, row5].join("\n")
    end
    
    def turn
      @x_turn ? "X" : "O"
    end
    
    def move(player, position)
      return "Invalid player"   unless valid_player?(player)
      return "Invalid turn"     unless players_turn?(player)
      return "Invalid position" unless valid_position?(position)
          
      @board[position] = player
  
      return "Winner: #{player}" if player_win?(player)
      return "Winner: None" if board_full?
      
      switch_players
      return board
    end
    
  private
    
    def valid_player?(player)
      (player == "X" || player == "O") ? true : false
    end
    
    def players_turn?(player)
      if (@x_turn && player == "X") || (!@x_turn && player == "O") 
        true
      else
        false
      end  
    end
    
    def valid_position?(position)
      @board[position].chr == "." ? true : false
    end
    
    def player_win?(player)
      win_patterns = self.class.const_get("#{player}_WIN_PATTERNS")
      win_patterns.inject(false) {|result, win_pattern| !!@board.match(win_pattern) || result}
    end
    
    def board_full?
      !@board.include?(".") ? true : false
    end
    
    def switch_players
      @x_turn = !@x_turn
    end
  end
  
  class Server
    def initialize(options={})
      @port = options[:port] || 7890
    end
  end
end

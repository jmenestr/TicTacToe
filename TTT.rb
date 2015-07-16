require 'set'

class Game

    LINES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

    def initialize(player1, player2, game_board = Board.new)
      @players = [Player.new(player1, "X",@game),Player.new(player2,"O",@game)].shuffle
      @current_player = @players[0]
      @other_player = @players[1]
      @game = game_board
      puts "#{@current_player.name} has been chosen to go first"
      self.play
    end

    attr_accessor :game,:current_player,:other_player
    def switch_players
      @current_player, @other_player = @other_player, @current_player
    end

    def ask_for_move(current_player)
      puts @game.print_board
      puts "Select your #{current_player.marker} position: "
      selection = gets.chomp.to_i
      loop do
        return selection if @game.free_positions.include?(selection) && (1..9).include?(selection)
        print "Please try again: "
        selection = gets.chomp.to_i
      end
    end

    def play      
      loop do    
          puts "#{@current_player.name} choose a position between 1-9: "
          choice = ask_for_move(@current_player)
        @game.set_position!(choice, @current_player.marker)
        if win?(@current_player) #Need to fix, currently will display wrong player if
          # previous move won since change palyer is in move! function
          @game.print_board
          puts "#{@current_player.name} has won"

          break
        elsif draw?
          @game.print_board
          puts "Draw!"
          break
        end
        switch_players
      end
    end

    def get_new_state(position)
      @game.set_position(position,@current_player)

    end

    def draw?
      @game.free_positions.empty?
    end

    def win?(player)
      LINES.any? do |line|
        line.all? do |position| 
          @game.board[position] == player.marker
        end
      end
    end

    def over?
      draw? or win?(@current_player) or win?(@other_player)
    end


end

class Board

  def initialize(board = Array.new(10,nil))
    @board = board
  end

  attr_accessor :board

  def print_board # Prints game Board
      row_seperator, column_seperator = '--+--+--', ' | ' #labels for columb and row seperators
      #lambda for generating labels based on if the position is empty or has a marker
      position_labels = lambda { |position| @board[position] ? @board[position]: position  } 
      rows = [[1,2,3],[4,5,6],[7,8,9]]
      row_for_display = lambda {|row| row.map(&position_labels).join(column_seperator)}
      rows_for_display = rows.map(&row_for_display)
      puts rows_for_display.join("\n#{row_seperator}\n")
  end

    def set_position!(position,marker) #set board square at position with marker
      @board[position] = marker
    end

    def free_positions #find free positions on game board
      Set.new(1..9).select {|position| @board[position].nil?}
    end

    def board_full?
      free_positions.empty?
    end

end

class Player
  def initialize(name,marker,game,computer = false)
    @name = name
    @marker = marker
  end
  attr_accessor :name, :marker
end

class ComputerPlayer
  def choose_move(game_state) # gamestate will be a GameState Object
    minimax(game_state)
    return @choice
  end

    def score(game_state)

      if game_state.game.win?(game_state.opponent) #fill in self with appropriate variables after sketch out solution
        return 10
      elsif game_state.game.win?(game_state.current_player) #fill in opponent with appropriate variables after sketch out solution
        return 10
      elsif game_state.game.draw?
        return 0
      end

    end

    def minimax(game_state)
      return score(game_state) if game_state.game.over?
      socres = []
      moves = []

      game_state.game.board.free_positions.each do |position|
        possible_state = game_state.new_state(move)
        scores.push minimax(possible_state)
        moves.push move
      end

      #Do Max Calculation
      if game_state.current_player = self
        max_score_index = socres.each_with_index.max[1]
        @choice = moves[max_score_index]
        return scores[max_score_index]
      else
        min_score_index = socres.each_with_index.min[1]
        @choice = moves[min_score_index]
        return scores[min_score_index]
      end
    
      @choice
    end

end

class GameState
  def initialize(game, current_player, opponent) # game must be put in as self
    @game = game #game object
    @current_player = current_player
    @opponent = opponent
  end

  attr_reader :current_player, :opponent

  def new_state(move)
    new_game = @game.board.set_position!(move,@current_player.marker)
    GameState.new(new_game,@opponent,@current_player)
  end

end

# Steps to create AI for game
# 1. Generate a new game state for each move
# 2. Identify the player that made the last move
# 3. For each state, check to see if it's a win, lose, draw, or no result
# 4. If the move is for the current player, find max score, otherwise, find min score
# 5. 




Game.new("Justin","Kristen")
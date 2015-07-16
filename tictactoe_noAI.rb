
require 'set'


  class Game

    LINES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

    debug = true 
    if debug
      attr_accessor :board,:players
    end

    def initialize(player_1,player_2)
      @board = Array.new(10);
      @players = [player_1.new(self,"x"),player_2.new(self,"o")] #initialize players and pass to them the game
      @current_player_id = 0 
      @last_move = nil
      puts "Player #{@current_player_id} goes first"
      self.play
    end


    def print_game # Prints game Board
      row_seperator, column_seperator = '--+--+--', ' | ' #labels for columb and row seperators
      #lambda for generating labels based on if the position is empty or has a marker
      position_labels = lambda { |position| @board[position] ? @board[position]: position  } 
      rows = [[1,2,3],[4,5,6],[7,8,9]]
      row_for_display = lambda {|row| row.map(&position_labels).join(column_seperator)}
      rows_for_display = rows.map(&row_for_display)
      puts rows_for_display.join("\n#{row_seperator}\n")

    end

    def play
      loop do 
        selection = current_player.select_position!
        move!(selection)
        if win?(current_player) #Need to fix, currently will display wrong player if
          # previous move won since change palyer is in move! function
          print_game
          puts "Player #{@current_player_id} has won"
          break
        elsif draw?
          print_game
          puts "Draw!"
          break
        end
      switch_players! #Switch players after each move
      
    end

    end

    #Following Code handles current and oponent player labels

    def current_player
      @players[@current_player_id]
    end

    def other_player_id
      1 - @current_player_id 
    end

    def opponent
      @players[1 - @current_player_id ]
    end

    def switch_players!
      @current_player_id = other_player_id
    end

    def undo_move!
    end

    def turn_count
      10 - @board.free_positions.size
    end

    def win?(player)

      LINES.any? do |line|
        line.all? do |position| 
          @board[position] == player.marker
        end
      end

    end


    def free_positions
      Set.new(1..9).select {|position| @board[position].nil?} #returns array of free position on board
    end

    def draw?
      free_positions.empty?
    end

    def over?
      draw? or win?(current_player) or win?(opponent)
    end

    def free_position?(position) 
      @board[position].nil?
    end

    def move!(position)
      if free_position?(position)
        @board[position] = current_player.marker
      end
    end

    def board_full?
      free_positions.empty?
    end
    
  end


  class Player

    def initialize(game,marker)
      @game = game
      @marker = marker
    end

    attr_reader :marker

  end

  class HumanPlayer < Player 
    def select_position!
      puts @game.print_game
      print "Select your #{marker} position: "
      selection = gets.chomp.to_i
      loop do
        return selection if @game.free_position?(selection) && (1..9).include?(selection)
        print "Please try again: "
        selection = gets.chomp.to_i
      end
    end
  end

  class ComputerPlayer < Player

    def select_position!
      minmax
      return @choice
      #return winning_move if winning_move
      #return @game.free_positions.shuffle[0]
    end

    # Rules for the Computer
    # 1. Win: Play a winning position if one is free
    # 2. Block: Play a block if the opponent can win on their next turn
    # 3. 
    # 

  end





game = Game.new(HumanPlayer, HumanPlayer)




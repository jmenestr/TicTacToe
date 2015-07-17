module TicTacToe
  require 'set'

  class Game

    LINES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

    def initialize(player1, player2, game_board = Board.new)
      @players = [Computer.new("X",self),Computer.new("O",self)].shuffle
      @current_player = @players[0]
      @other_player = @players[1]
      @game = game_board
      #puts "#{@current_player.name} has been chosen to go first"
      self.play
    end

    attr_accessor :game,:current_player,:other_player, :game_board
    def switch_players
      @current_player, @other_player = @other_player, @current_player
    end

    def ask_for_move(current_player)
      puts @game.print_board
      puts "Select your #{current_player.marker} position (1-9): "
      selection = gets.chomp.to_i
      loop do
        return selection if @game.free_positions.include?(selection) && (1..9).include?(selection)
        print "Please try again: "
        selection = gets.chomp.to_i
      end
    end

    def play
      loop do
        #Handles case of computer player and human player
        if !@current_player.computer
          choice = ask_for_move(@current_player)
        else
          choice = @current_player.choose_move
        end
        @game.set_position!(choice, @current_player.marker)
        if win?(@current_player) #Need to fix, currently will display wrong player if
          # previous move won since change palyer is in move! function
          @game.print_board
          puts "#{@current_player} has won"

          break
        elsif draw?
          @game.print_board
          puts "Draw!"
          break
        end
        switch_players
      end
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
end
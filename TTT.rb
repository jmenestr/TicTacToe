require 'set'

class Game

  LINES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

  def initialize(player1, player2, game_board = Board.new)
    @players = [Computer.new("X",self),Human.new("Justin","O")].shuffle
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

  def get_position(position)
    @board[position]
  end

  def free_positions #find free positions on game board
    Set.new(1..9).select {|position| @board[position].nil?}
  end

  def free_position?(position)
    return free_positions.include?(position)
  end

  def board_full?
    free_positions.empty?
  end

end

class Human
  def initialize(name,marker)
    @name = name
    @marker = marker
    @computer = false
  end
  attr_accessor :name, :marker, :computer
end

class Computer
  #Create AI To play game
  # Situations AI will look out for
  # 1. If it has a winning move, take it
  # 2. If Human has a winning move, block it
  def initialize(marker,game)
    @game = game
    @marker = marker
    @computer = true
  end

  attr_reader  :marker, :computer

  def opponent_marker
    if @marker == "X"
      "O"
    else
      "X"
    end
  end

  def choose_move
    return look_for_win if look_for_win
    return look_for_lose if look_for_lose
    return check_for_fork if check_for_fork
    return look_for_center if look_for_center
    return opposite_corner if opposite_corner
    return empty_corner if empty_corner
    empty_side
  end

  def group_positions_by_marker(line)
    markers = line.group_by {|position| @game.game.board[position]}
    markers.default = []
    markers
  end

  def look_for_win
    Game::LINES.each do |winning_line|
      markers = group_positions_by_marker(winning_line)
      if markers[self.marker].length == 2
        return markers[nil].first
      end
    end
    false
  end

  def look_for_center
    center = 5
    return center if @game.game.free_position?(center)
    false
  end

  def opposite_corner
    corners_opposite = {1=>9,3=>7,7=>3,9=>1}
    corners = corners_opposite.keys
    corners.each do |corner|
      opposite_corner = corners_opposite[corner]
      if @game.game.get_position(corner) == opponent_marker and @game.game.free_position?(opposite_corner)
        return corners_opposite[corner]
      end
    end
    false
  end

  def empty_corner
    corners = [1,3,7,9]
    corners.each do |corner|
      if @game.game.free_position?(corner)
        return corner
      end
    end
    false
  end

  def empty_side
    sides = [2,4,6,8]
    sides.each do |side|
      return side if @game.game.free_position?(side)
    end
  end

  def look_for_lose
    Game::LINES.each do |winning_line|
      markers = group_positions_by_marker(winning_line)
      if markers[@game.other_player.marker].length == 2
        return markers[nil].first
      end
    end
    false
  end

  # Fork Logic
  # Need to work on this. For some reason even after cloning I am still modifying the base @game object that I want to avoid changing
  ##########################################################################################
  def possible_fork?(game_state)
    possible_wins = 0
    Game::LINES.each do |winning_line|
      markers = winning_line.group_by {|position|game_state.game.board[position]}
      if markers.has_key?(self.marker) && markers[self.marker].length == 2
        possible_wins += 1
      end
      return true if possible_wins == 2
    end

    false
  end

  def check_for_fork
    @game.game.free_positions.each do |position|
      possible_game = @game.clone
      possible_game.game = @game.game.clone
      possible_game.game.board = @game.game.board.clone
      possible_game.game.set_position!(position,marker)
      return position if possible_fork?(possible_game)
    end
      false
  end

  ##########################################################################################
end




Game.new("Justin","Kristen")

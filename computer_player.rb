require_relative "game"

module TicTacToe
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

    # The computer follows the logic in the following order, choosing the higest
    # true case:
    #   1: If there is a winning move, the computer will take it
    #   2: If the opponent has a winning move, the computer will block it
    #   3: If the computer has a move that causes a fork such that there will be 2 winning
    #     moves on the next turn, it will take it
    #   4: If the center space is free, it will take it
    #   5: If the opponent played an corner and the opposing corner is open, it will take it
    #   6: If there is an empty corner, it will take it
    #   7: If there is an emtpy side, it will take it
    
      return look_for_win if look_for_win
      return look_for_lose if look_for_lose
      return check_for_fork if check_for_fork
      #return check_for_fork(opponent_marker) if check_for_fork(opponent_marker)
      return look_for_center if look_for_center
      return opposite_corner if opposite_corner
      return empty_corner if empty_corner
      empty_side


  end


  # Given a Winning line, returns a hash grouped by which board markers lie which part of the line
  def group_positions_by_marker(line)
    markers = line.group_by {|position| @game.game.board[position]}
    markers.default = []
    markers
  end


    #Looks for a winning move by looking at winning lines
  def look_for_win
    Game::LINES.each do |winning_line|
      markers = group_positions_by_marker(winning_line)
         if markers[marker].length == 2 and markers.keys.include?(nil)
           puts markers.keys
          choice = markers[nil].first
           return choice
         end
      end
      false
  end

    # Checks to see if there is a winning move for opponent and if there is will block it
  def look_for_lose
    Game::LINES.each do |winning_line|
      markers = group_positions_by_marker(winning_line)
      if markers[@game.other_player.marker].length == 2 and markers.keys.include?(nil)
        return  markers[nil].first
      end
    end
    false
  end

  #Looks for to see if a center square is open and if not chooses it
  def look_for_center
    center = 5
    return center if @game.game.free_position?(center)
    false
  end

  #Checks to see if corner squares are occupied by the opposing player
  # and if one is will play the opposing corner if free
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
  # Checks to see if a corner is empty and will chose one if it is
  def empty_corner
    corners = [1,3,7,9]
    corners.select! {|corner| @game.game.free_position?(corner) }
    return corners.shuffle.first if !corners.empty?
    false
  end

  # Checks to see if the middle square on each side is emtpy and will choose one to play
  def empty_side
    sides = [2,4,6,8]
    sides.each do |side|
      return side if @game.game.free_position?(side)
    end
  end


    # Fork Logic
    # 
    # 
    # Takes a game that that is advanced by one move and looks to see if there are 
    # two possible ways to win the game. Returns true if there are
    def possible_fork?(game_state)
      possible_wins = 0
      Game::LINES.each do |winning_line|
        markers = winning_line.group_by {|position|game_state.game.board[position]}
        if  markers[marker] and markers[marker].length == 2 and markers.keys.include?(nil)
          possible_wins += 1
        end
        return true if possible_wins == 2
      end

      false
    end
    # Iterates through each free position in the current game state, playes that move,
    # and then calls Computer#possible_fork? to see if that state results in 2 winning
    # positions. 
    # Returns position for which that is true, false otherwise
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

end
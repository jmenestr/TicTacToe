module TicTacToe

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
end
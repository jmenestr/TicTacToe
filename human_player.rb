module TicTacToe
  class Human
    def initialize(name,marker)
      @name = name
      @marker = marker
      @computer = false
    end
    attr_accessor :name, :marker, :computer
  end
end

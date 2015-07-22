require_relative 'board'
require_relative 'computer_player'
require_relative 'human_player'
require_relative 'game'
10000.times do
  TicTacToe::Game.new("Justin","Kristen")

end

board = [nil,"O","O","X",nil,"X",nil,nil,"X"]
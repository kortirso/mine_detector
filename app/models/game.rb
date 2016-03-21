class Game < ActiveRecord::Base
    has_many :cells

    validates :game_result, inclusion: { in: %w(none Победа Поражение) }

    def self.build
        game = create start: false
        Cell.build(game.id)
        game.set_mines
        game
    end

    def set_mines
        x_param, y_param, mines_list = %w(a b c d e f g h i j), %w(1 2 3 4 5 6 7 8 9 10), []
        mines_count = rand(5) + 10
        mines_count.times do |i|
            rand_cell = "#{x_param[rand(9)]}#{y_param[rand(9)]}"
            while self.cells.find_by(name: rand_cell).has_mine
                rand_cell = "#{x_param[rand(9)]}#{y_param[rand(9)]}"
            end
            mines_list.push(rand_cell)
            self.cells.find_by(name: rand_cell).update(has_mine: true)
        end
        self.update(start: true, mines: mines_list, mines_count: mines_count) unless self.start
        Cell.set_around(self.id)
    end
end

class Game < ActiveRecord::Base
    belongs_to :user
    has_many :cells

    validates :game_result, presence: true, inclusion: { in: %w(none Победа Поражение) }

    def self.build(user_id)
        game = user_id.is_a?(String) ? create(guest: user_id) : create(user_id: user_id)
        Cell.build(game.id)
        game.set_mines
        game
    end

    def set_mines
        x_param, y_param, mines_list, cell_list = %w(a b c d e f g h i j), %w(1 2 3 4 5 6 7 8 9 10), [], self.cells
        mines_count = rand(6) + 10
        mines_count.times do |i|
            rand_cell = "#{x_param[rand(10)]}#{y_param[rand(10)]}"
            rand_cell = "#{x_param[rand(10)]}#{y_param[rand(10)]}" while mines_list.include?(rand_cell)
            mines_list.push(rand_cell)
            cell_list.find_by(name: rand_cell).update(has_mine: true)
        end
        self.update(mines_count: mines_count)
        Cell.set_around(self.id)
    end
end

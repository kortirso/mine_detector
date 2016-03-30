class Cell < ActiveRecord::Base
    belongs_to :game

    validates :game_id, :x_param, :y_param, :name, :around, presence: true
    validates :x_param, inclusion: { in: %w(a b c d e f g h i j) }
    validates :y_param, inclusion: { in: %w(1 2 3 4 5 6 7 8 9 10) }

    def self.build(game_id)
        inserts, t = [], Time.current
        %w(a b c d e f g h i j).each do |x|
            %w(1 2 3 4 5 6 7 8 9 10).each { |y| inserts.push "(#{game_id}, '#{x}', '#{y}', '#{x + y}', '#{t}', '#{t}')" }
        end
        Cell.connection.execute "INSERT INTO cells (game_id, x_param, y_param, name, created_at, updated_at) VALUES #{inserts.join(", ")}"
    end

    def check_cell
        @result = []
        if self.has_mine == false
                @result.push([self.name, self.around])
                self.update(opened: true)
            if self.around == 0
                @x_params, @y_params, @empties, @cell_list = %w(a b c d e f g h i j), %w(1 2 3 4 5 6 7 8 9 10), [], self.game.cells
                open_cell(self)
                until @empties == []
                    checks = @empties
                    @empties = []
                    checks.each { |empty_name| open_cell(@cell_list.find_by(name: empty_name)) }
                end
            end
        else
            current_game = self.game
            current_game.update(game_result: 'Поражение', times: (Time.current.to_i - current_game.starttime))
            current_game.cells.where(has_mine: true).each { |mine| @result.push([mine.name, 'mine']) }
        end
        @result
    end

    def self.set_around(game_id)
        x_params, y_params, around_list, result_list, game_cells = %w(a b c d e f g h i j), %w(1 2 3 4 5 6 7 8 9 10), [], [], Game.find(game_id).cells
        game_cells.where(has_mine: true).each do |cell|
            x_index, y_index = x_params.index(cell.x_param), y_params.index(cell.y_param)
            [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].each do |i|
                x_new, y_new = x_index + i[0], y_index + i[1]
                around_list.push("#{x_params[x_new]}#{y_params[y_new]}") if (0..9).include?(x_new) && (0..9).include?(y_new)
            end
        end
        around_list.sort!.each do |cell|
            if result_list == []
                result_list.push([cell, 1])
            else
                result_list[-1][0] == cell ? result_list[-1][1] += 1 : result_list.push([cell, 1])
            end
        end
        Cell.transaction do
            result_list.each { |cell| game_cells.find_by(name: cell[0]).update(around: cell[1]) }
        end
    end

    def marking(res)
        self.update(marked: res)
        res == true ? [[self.name, 'marked']] : [[self.name, 'unmarked']]
    end

    private
    def open_cell(object)
        x_index, y_index = @x_params.index(object.x_param), @y_params.index(object.y_param)
        [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].each do |i|
            x_new, y_new = x_index + i[0], y_index + i[1]
            if (0..9).include?(x_new) && (0..9).include?(y_new)
                cell_new = @cell_list.find_by(name: "#{@x_params[x_new]}#{@y_params[y_new]}")
                unless cell_new.opened
                    cell_new.update(opened: true)
                    @result.push([cell_new.name, cell_new.around])
                    @empties.push(cell_new.name) if cell_new.around == 0
                end
            end
        end
    end
end

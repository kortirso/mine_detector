class Cell < ActiveRecord::Base
    belongs_to :game

    validates :game_id, :x_param, :y_param, :name, presence: true
    validates :x_param, inclusion: { in: %w(a b c d e f g h i j) }
    validates :y_param, inclusion: { in: %w(1 2 3 4 5 6 7 8 9 10) }

    def self.build(game_id)
        %w(a b c d e f g h i j).each do |x|
            %w(1 2 3 4 5 6 7 8 9 10).each do |y|
                create game_id: game_id, x_param: x, y_param: y, name: "#{x}#{y}"
            end
        end
    end

    def check_cell
        result = []
        if self.has_mine == false
                result.push([self.name, self.around])
                self.update(opened: true)
            if self.around == 0 # если вокруг нет мин, то открыть все ячейки вокруг
                x_params, y_params, empties = %w(a b c d e f g h i j), %w(1 2 3 4 5 6 7 8 9 10), []
                x_index, y_index = x_params.index(self.x_param), y_params.index(self.y_param)
                cell_list = self.game.cells
                [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].each do |i|
                    x_new, y_new = x_index + i[0], y_index + i[1]
                    if x_new >= 0 && x_new <= 9 && y_new >= 0 && y_new <= 9
                        cell_new = cell_list.find_by(name: "#{x_params[x_new]}#{y_params[y_new]}")
                        unless cell_new.opened
                            cell_new.update(opened: true)
                            result.push([cell_new.name, cell_new.around])
                            empties.push(cell_new.name) if cell_new.around == 0
                        end
                    end
                end
                until empties == [] # если сохраняются нулевые ячейки, то снова проверить вокруг, повторять пока не останется пустых
                    checks = empties
                    empties = []
                    checks.each do |empty_name|
                        empty = cell_list.find_by(name: empty_name)
                        x_index, y_index = x_params.index(empty.x_param), y_params.index(empty.y_param)
                        [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].each do |i|
                            x_new, y_new = x_index + i[0], y_index + i[1]
                            if x_new >= 0 && x_new <= 9 && y_new >= 0 && y_new <= 9
                                cell_new = cell_list.find_by(name: "#{x_params[x_new]}#{y_params[y_new]}")
                                unless cell_new.opened
                                    cell_new.update(opened: true)
                                    result.push([cell_new.name, cell_new.around])
                                    empties.push(cell_new.name) if cell_new.around == 0
                                end
                            end
                        end
                    end
                end
            end
        else
            self.game.update(game_result: 'Поражение', times: (Time.current.to_i - self.game.starttime))
            self.game.cells.where(has_mine: true).each { |mine| result.push([mine.name, 'mine']) }
        end
        result
    end

    def self.set_around(game_id)
        x_params, y_params = %w(a b c d e f g h i j), %w(1 2 3 4 5 6 7 8 9 10)
        game = Game.find(game_id)
        mines = game.mines
        cells = game.cells.where(has_mine: false)
        cells.each do |cell|
            around, x_index, y_index = 0, x_params.index(cell.x_param), y_params.index(cell.y_param)
            [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].each do |i| # проверка 8 ячеек вокруг
                x_new, y_new = x_index + i[0], y_index + i[1]
                if x_new >= 0 && x_new <= 9 && y_new >= 0 && y_new <= 9
                    cell_new = "#{x_params[x_new]}#{y_params[y_new]}"
                    around += 1 if mines.include?(cell_new) # если в список мин входит выбранная ячейка, то индикатор + 1
                end
            end
            cell.update(around: around)
        end
    end

    def marking(res)
        self.update(marked: res)
        res == true ? [[self.name, 'marked']] : [[self.name, 'unmarked']]
    end
end

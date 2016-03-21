class GamesController < ApplicationController
    def index
        game = Game.build
    end

    def click
        @game = Game.last
        if @game.game_result == 'none'
            cell = @game.cells.find_by(name: "#{params[:name]}")
            if cell.opened
                render nothing: true
            else
                if cell.marked
                    @cell_list = cell.marking(false)
                else
                    @cell_list = params[:click] == '1' ? cell.check_cell : @cell_list = cell.marking(true)
                end
                @game.update(game_result: 'Победа') if @game.cells.where(opened: false).count == @game.mines_count
            end
        else
            render nothing: true
        end
    end
end

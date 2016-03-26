class GamesController < ApplicationController
    before_action :authenticate_user!, only: :profile
    before_action :update_games, except: [:click, :champions]

    def index
        @game = Game.build(current_user ? current_user.id : session[:guest])
    end

    def click
        @game = current_user ? Game.where(user_id: current_user.id).last : Game.where(guest: session[:guest]).last
        if @game.game_result == 'none'
            cell = @game.cells.find_by(name: "#{params[:name]}")
            if cell.opened
                render nothing: true
            else
                if cell.marked
                    @cell_list = cell.marking(false)
                else
                    @cell_list = params[:click] == '1' ? cell.check_cell : (@cell_list = cell.marking(true))
                end
                @game.update(starttime: Time.current.to_i) if @game.starttime == 0
                @game.update(game_result: 'Победа', times: (Time.current.to_i - @game.starttime)) if @game.cells.where(opened: false).count == @game.mines_count
            end
        else
            render nothing: true
        end
    end

    def profile
        games = Game.where(user_id: current_user.id).order(times: :asc)
        @wins = games.where(game_result: 'Победа')
        @defeat_count = games.where(game_result: 'Поражение').count
    end

    def champions
        @games = Game.where(game_result: 'Победа').order(times: :asc).limit(10)
    end

    private
    def update_games
        games = current_user ? Game.where(user_id: current_user.id, game_result: 'none') : Game.where(guest: session[:guest], game_result: 'none')
        games.each { |game| game.update(game_result: 'Поражение') } if games.count > 0
    end
end

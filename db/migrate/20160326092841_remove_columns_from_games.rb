class RemoveColumnsFromGames < ActiveRecord::Migration
    def change
        remove_column :games, :start
        remove_column :games, :mines
    end
end

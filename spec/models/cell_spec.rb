RSpec.describe Cell, type: :model do
    it { should belong_to :game }
    it { should validate_presence_of :game_id }
    it { should validate_presence_of :x_param }
    it { should validate_presence_of :y_param }
    it { should validate_presence_of :name }
    it { should validate_presence_of :around }
    it { should validate_inclusion_of(:x_param).in_array(%w(a b c d e f g h i j)) }
    it { should validate_inclusion_of(:y_param).in_array(%w(1 2 3 4 5 6 7 8 9 10)) }

    it 'should be valid' do
        cell = create :cell

        expect(cell).to be_valid
    end

    describe 'Methods' do
        let!(:game) { create :game }

        context '.build' do
            it 'creates 100 cells for game' do
                expect { Cell.build(game.id) }.to change(game.cells, :count).by(100)
            end
        end

        describe 'at the game' do
            before { Cell.build(game.id) }

            context '.check_cell' do
                before { game.set_mines }

                context 'if cell without mine' do
                    let!(:cell) { game.cells.where(has_mine: false).where('around > 0').last }

                    it 'cell marked as open' do
                        expect { cell.check_cell }.to change(cell, :opened).from(false).to(true)
                    end

                    it 'and return name of cell' do
                        expect(cell.check_cell).to eq [[cell.name, cell.around]]
                    end

                    context 'and if around eq to 0' do
                        let!(:cell_empty) { game.cells.where(has_mine: false, around: 0).last }

                        it 'opened cell more than 1' do
                            start_count = game.cells.where(opened: true).count
                            cell_empty.check_cell

                            expect(game.cells.where(opened: true).count - start_count).to be > 1
                        end

                        it 'and they havenot mines' do
                            cell_empty.check_cell

                            expect(game.cells.where(opened: true, has_mine: true).count).to eq 0
                        end
                    end
                end

                context 'if cell with mine' do
                    let!(:cell) { game.cells.where(has_mine: true).last }

                    it 'then game is over' do
                        expect { cell.check_cell }.to change(game, :game_result).from('none').to('Поражение')
                    end

                    it 'has game.times' do
                        expect { cell.check_cell }.to change(game, :times)
                    end

                    it 'and returns list of cells with mines' do
                        list = []
                        game.cells.where(has_mine: true).each { |cell| list.push([cell.name, 'mine']) }

                        expect(cell.check_cell).to eq list
                    end
                end
            end

            context '.set_around' do
                it 'cells dont have around before' do
                    game.cells.where(has_mine: false).each { |cell| expect(cell.around).to eq 0 }
                end

                it 'around of each cell has number of around mines' do
                    game.set_mines
                    game_cells = game.cells
                    game_cells.where(has_mine: false).each do |cell|
                        x_params, y_params = %w(a b c d e f g h i j), %w(1 2 3 4 5 6 7 8 9 10)
                        x_index, y_index = x_params.index(cell.x_param), y_params.index(cell.y_param)
                        around = 0
                        [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].each do |i|
                            x_new, y_new = x_index + i[0], y_index + i[1]
                            if (0..9).include?(x_new) && (0..9).include?(y_new)
                                around += 1 if game_cells.find_by(name: "#{x_params[x_new]}#{y_params[y_new]}").has_mine
                            end
                        end

                        expect(cell.around).to eq around
                    end
                end
            end

            context '.marking' do
                context 'if get true' do
                    it 'be marked' do
                        game.cells.last.marking(true)

                        expect(game.cells.last.marked).to eq true
                    end

                    it 'and return [[cell.name, marked]]' do
                        expect(game.cells.last.marking(true)).to eq [[game.cells.last.name, 'marked']]
                    end
                end

                context 'if get false' do
                    it 'be unmarked' do
                        game.cells.last.marking(false)

                        expect(game.cells.last.marked).to eq false
                    end

                    it 'and return [[cell.name, unmarked]]' do
                        expect(game.cells.last.marking(false)).to eq [[game.cells.last.name, 'unmarked']]
                    end
                end
            end
        end
    end
end

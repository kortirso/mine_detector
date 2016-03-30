RSpec.describe Game, type: :model do
    it { should belong_to :user }
    it { should have_many :cells }
    it { should validate_presence_of :game_result }
    it { should validate_inclusion_of(:game_result).in_array(%w(none Победа Поражение)) }

    it 'should be valid' do
        game = create :game

        expect(game).to be_valid
    end

    describe 'Methods' do
        context '.build' do
            it 'for quest' do
                expect(Game.build(Digest::MD5.hexdigest(Time.current.to_s))).to be_valid
            end

            it 'for user' do
                expect(Game.build(create :user)).to be_valid
            end

            it 'creates 100 cells' do
                expect { Game.build(create :user) }.to change(Cell, :count).by(100)
            end

            it 'and they belongs_to game' do
                game = Game.build(create :user)

                expect(game.cells.count).to eq 100
            end
        end

        context '.set_mines' do
            let!(:game) { create :game }
            before do
                Cell.build(game.id)
                game.set_mines
            end

            it 'mines count from 10 to 15' do
                expect((10..15).include?(game.cells.where(has_mine: true).count)).to eq true
            end

            it 'and cells with mines are different' do
                massiv = []
                game.cells.where(has_mine: true).each { |cell| massiv.push(cell) }
                massiv.uniq!

                expect(massiv.size).to eq game.cells.where(has_mine: true).count
            end

            it 'and game.mines_count eq mines count' do
                expect(game.mines_count).to eq game.cells.where(has_mine: true).count
            end
        end
    end
end

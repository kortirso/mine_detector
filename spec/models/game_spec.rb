RSpec.describe Game, type: :model do
    it { should belong_to :user }
    it { should have_many :cells }
    it { should validate_presence_of :game_result }
    it { should validate_inclusion_of(:game_result).in_array(%w(none Победа Поражение)) }

    it 'should be valid' do
        game = create :game

        expect(game).to be_valid
    end
end

RSpec.describe Cell, type: :model do
    it { should belong_to :game }
    it { should validate_presence_of :game_id }
    it { should validate_presence_of :x_param }
    it { should validate_presence_of :y_param }
    it { should validate_presence_of :name }
    it { should validate_inclusion_of(:x_param).in_array(%w(a b c d e f g h i j)) }
    it { should validate_inclusion_of(:y_param).in_array(%w(1 2 3 4 5 6 7 8 9 10)) }

    it 'should be valid' do
        cell = create :cell

        expect(cell).to be_valid
    end
end

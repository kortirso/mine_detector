RSpec.describe User, type: :model do
    it { should have_many :games }
    it { should validate_presence_of :username }
    it { should validate_presence_of :password }
    it { should validate_uniqueness_of :username }
    it { should validate_length_of :username }

    it 'is valid with username and password' do
        user = User.new(username: 'tester', password: 'password')

        expect(user).to be_valid
    end

    it 'is invalid without username' do
        user = User.new(username: nil)
        user.valid?

        expect(user.errors[:username]).to include("can't be blank")
    end

    it 'is invalid without password' do
        user = User.new(password: nil)
        user.valid?

        expect(user.errors[:password]).to include("can't be blank")
    end

    it 'is invalid with a duplicate username' do
        User.create(username: 'tester1', password: 'password')
        user = User.new(username: 'tester1', password: 'password')
        user.valid?

        expect(user.errors[:username]).to include('has already been taken')
    end
end
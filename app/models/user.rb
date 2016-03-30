class User < ActiveRecord::Base
    devise :database_authenticatable, :registerable, :rememberable, :trackable

    has_many :games

    validates :username, presence: true, uniqueness: true, length: { in: 1..20 }
    validates :password, presence: true
end

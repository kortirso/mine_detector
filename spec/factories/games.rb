FactoryGirl.define do
    factory :game do
        association :user
        game_result 'none'
    end
end

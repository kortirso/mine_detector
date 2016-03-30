FactoryGirl.define do
    factory :cell do
        association :game
        x_param 'a'
        y_param '1'
        name 'a1'
    end
end

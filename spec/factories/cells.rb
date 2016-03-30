FactoryGirl.define do
    factory :cell do
        association :game
        x_param 'a'
        y_param '1'
        name 'a1'
        around 1
        has_mine false
        opened false
        marked false

        trait :empty do
            around 0
        end
    end
end

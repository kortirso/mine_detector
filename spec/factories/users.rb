FactoryGirl.define do
    factory :user do
        sequence(:username) { |i| "tester#{i}" }
        password 'password'
    end
end
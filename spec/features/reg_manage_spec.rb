require_relative 'feature_helper'

RSpec.feature 'Registration management', type: :feature do
    describe 'Unauthenticated user can' do
        context 'try sign up' do
            before { visit root_path }

            it 'with all information' do
                click_on 'up'
                within('#sign_up form#new_user') do
                    fill_in 'user_username', with: 'test'
                    fill_in 'user_password', with: 'password'
                    fill_in 'user_password_confirmation', with: 'password'

                    click_button 'Регистрация'
                end

                expect(page).to have_content 'Профиль'
            end

            it 'without all information' do
                click_on 'up'
                within('#sign_up form#new_user') do
                    fill_in 'user_username', with: ''
                    fill_in 'user_password', with: 'password'
                    fill_in 'user_password_confirmation', with: 'password'

                    click_button 'Регистрация'
                end

                expect(page).to have_content 'Регистрация'
            end
        end

        context 'try login' do
            let(:user) { create :user }
            before { visit root_path }

            it 'when he registered' do
                click_on 'log'
                within('#login form#new_user') do
                    fill_in 'user_username', with: user.username
                    fill_in 'user_password', with: user.password

                    click_button 'Авторизация'
                end

                expect(page).to have_content 'Профиль'
            end

            it 'without some information' do
                click_on 'log'
                within('#login form#new_user') do
                    fill_in 'user_username', with: ''
                    fill_in 'user_password', with: user.password

                    click_button 'Авторизация'
                end

                expect(page).to_not have_content 'Профиль'
                expect(page).to have_content 'Регистрация'
            end

            it 'when he not registered' do
                click_on 'log'
                within('#login form#new_user') do
                    fill_in 'user_username', with: 'random'
                    fill_in 'user_password', with: 'random_pass'

                    click_button 'Авторизация'
                end

                expect(page).to_not have_content 'Профиль'
                expect(page).to have_content 'Регистрация'
            end
        end
    end

    describe 'Logged user can' do
        let!(:user) { create(:user) }

        it 'logoff' do
            sign_in(user)
            click_on 'destroy'

            expect(page).to have_content 'Регистрация'
        end
    end
end
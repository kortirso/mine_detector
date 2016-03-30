RSpec.describe GamesController, type: :controller do
    describe 'GET #index' do
        it 'assigns the requested game to @game' do
            get :index

            expect(assigns(:game)).to eq Game.last
        end

        context 'for registered user' do
            sign_in_user
            let!(:game) { create :game, user: @current_user }

            it 'complete all previous games' do
                get :index
                game.reload

                expect(game.game_result).to eq 'Поражение'
            end
        end
    end

    describe 'POST #click' do
        
    end

    describe 'GET #profile' do
        context 'for unregistered user' do
            it 'redirects to sign_in page' do
                get :profile

                expect(response).to redirect_to new_user_session_path
            end
        end

        context 'for registered user' do
            sign_in_user

            it 'assigns the all user wins to @wins' do
                get :profile

                expect(assigns(:wins)).to eq Game.where(user_id: @current_user.id).order(times: :asc).where(game_result: 'Победа')
            end

            it 'and assigns the count of user defeats to @defeat_count' do
                get :profile

                expect(assigns(:defeat_count)).to eq Game.where(user_id: @current_user.id).order(times: :asc).where(game_result: 'Поражение').count
            end

            it 'and render profile view' do
                get :profile

                expect(response).to render_template :profile
            end
        end
    end

    describe 'GET #champions' do
        it 'assigns the requested game to @game' do
            get :champions

            expect(assigns(:games)).to eq Game.where(game_result: 'Победа').order(times: :asc).limit(10)
        end

        it 'and render profile view' do
            get :champions

            expect(response).to render_template :champions
        end
    end
end

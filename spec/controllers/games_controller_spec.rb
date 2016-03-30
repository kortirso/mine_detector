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
        before { get :index }
        let!(:game) { Game.last }

        it 'if cell doesnt exist' do
            post :click, name: 'a0', click: '1', format: :js

            expect(response.body).to be_blank
        end

        context 'if cell exists' do
            it 'if cell opened, nothing' do
                game.cells.find_by(name: 'a1').update(opened: true)
                post :click, name: 'a1', click: '1', format: :js

                expect(response.body).to be_blank
            end

            it 'if cell closed and marked, cell will be unmarked' do
                game.cells.find_by(name: 'a1').update(opened: false, marked: true)
                post :click, name: 'a1', click: '1', format: :js

                expect(assigns(:cell_list)).to eq [['a1', 'unmarked']]
            end

            it 'if cell closed and not marked and Right-click, cell will be marked' do
                game.cells.find_by(name: 'a1').update(opened: false, marked: false)
                post :click, name: 'a1', click: '2', format: :js

                expect(assigns(:cell_list)).to eq [['a1', 'marked']]
            end

            it 'if cell closed and not marked, cell will be opened' do
                game.cells.find_by(name: 'a1').update(opened: false, marked: false, around: 1, has_mine: false)
                post :click, name: 'a1', click: '1', format: :js

                expect(assigns(:cell_list)).to eq [['a1', 1]]
            end
        end
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
            before { get :profile }

            it 'assigns the all user wins to @wins' do
                expect(assigns(:wins)).to eq Game.where(user_id: @current_user.id).order(times: :asc).where(game_result: 'Победа')
            end

            it 'and assigns the count of user defeats to @defeat_count' do
                expect(assigns(:defeat_count)).to eq Game.where(user_id: @current_user.id).order(times: :asc).where(game_result: 'Поражение').count
            end

            it 'and render profile view' do
                expect(response).to render_template :profile
            end
        end
    end

    describe 'GET #champions' do
        before { get :champions }

        it 'assigns the requested game to @game' do
            expect(assigns(:games)).to eq Game.where(game_result: 'Победа').order(times: :asc).limit(10)
        end

        it 'and render profile view' do
            expect(response).to render_template :champions
        end
    end
end

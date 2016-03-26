Rails.application.routes.draw do
    devise_for :users
    post 'square/:name/:click' => 'games#click'
    get 'profile' => 'games#profile', as: 'profile'
    get 'champions' => 'games#champions', as: 'champions'
    root to: 'games#index'
    match "*path", to: "application#catch_404", via: :all
end

Rails.application.routes.draw do
    post 'square/:name/:click' => 'games#click'
    root to: 'games#index'
end

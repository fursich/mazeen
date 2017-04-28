Rails.application.routes.draw do

  root to: 'maze#index'

  post 'maze/seek'
  post 'maze/redraw'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

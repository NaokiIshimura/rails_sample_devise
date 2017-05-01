Rails.application.routes.draw do
  get 'member_pages/page1'

  get 'member_pages/page2'

  get 'member_pages/page3'

  get 'home/show'
  get 'home/index'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
end

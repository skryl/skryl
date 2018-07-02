Rails.application.routes.draw do
  get 'books'            => 'books#index'
  get 'twitter/:options' => 'tweets#index'
  get 'twitter'          => 'tweets#index'
  get 'links'            => 'links#index'
  get 'sleep'            => 'sleep#index'
  get 'exercise'         => 'activities#index'

  root :to => 'home#index'
end
Dorian::Application.routes.draw do
  match 'books'   => 'books#index'
  match 'twitter/:options' => 'tweets#index'
  match 'twitter' => 'tweets#index'
  match 'links' => 'links#index'
  match 'sleep' => 'sleep#index'
  match 'exercise' => 'activities#index'

  root :to => 'home#index'
end

Rails.application.routes.draw do
  root 'notam#index'
  post '/results' => 'notam#results'
end

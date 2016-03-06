Rails.application.routes.draw do
  root to: 'visitors#index'
  get '/privacy', to: 'visitors#privacy'
  get '/support', to: 'visitors#support'
  post '/visitors/email_support', to: 'visitors#email_support'
  # slack
  post 'slackinterface', to: 'slack_interface#index'
  get 'slackinterface/setup', to: 'slack_interface#setup'
  post 'slackinterface/setup', to: 'slack_interface#setup'
  get 'slackinterface/oauth', to: 'slack_interface#oauth'
end

Rails.application.routes.draw do
  root to: 'visitors#index'

  # slack
  post 'slackinterface', to: 'slack_interface#index'
  get 'slackinterface/oauth', to: 'slack_interface#oauth'
end

Rails.application.routes.draw do
  root to: 'visitors#index'
  post 'toggl_accounts', to: 'toggl_accounts#create'
  delete 'toggl_accounts/:toggl_account_id', to: 'toggl_accounts#destroy'
  devise_for :users


  # slack
  post 'slackinterface', to: 'slack_interface#index'
  post 'slackinterface/oauth', to: 'slack_interface#oauth'
end

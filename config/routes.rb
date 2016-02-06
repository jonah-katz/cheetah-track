Rails.application.routes.draw do
  root to: 'visitors#index'
  post 'toggl_accounts', to: 'toggl_accounts#create'
  delete 'toggl_accounts/:toggl_account_id', to: 'toggl_accounts#destroy'


  # slack
  post 'slackinterface', to: 'slack_interface#index'
  get 'slackinterface/oauth', to: 'slack_interface#oauth'
end

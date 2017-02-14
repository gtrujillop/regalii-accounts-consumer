Rails.application.routes.draw do
  get 'get_accounts', to: 'processors#get_accounts'
  get 'send_results', to: 'processors#send_results'
end

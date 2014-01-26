# coding: utf-8
require 'devise'

require 'devise/models/custom_authenticatable'
require 'devise/strategies/custom_authenticatable'
require 'devise_custom_authenticatable/version'

Devise.add_module(:custom_authenticatable, {
  strategy: true,
  controller: :sessions,
  model: 'devise/models/custom_authenticatable'
})

# Be sure to restart your server when you modify this file.
require "redis-store"
Rails.application.config.session_store :cookie_store, key: '_weimall_session', :domain => :all
# Rails.application.config.session_store :redis_store,key: '_weimall_session',:servers => { :host =>REDIS_CONFIG[:address], :port => REDIS_CONFIG[:port], :db => 0, :namespace => 'sessions' },:domain => :all, :expire_after => 30.days

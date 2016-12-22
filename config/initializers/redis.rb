require "redis"
$redis = Redis.new(:host =>REDIS_CONFIG[:address],:port => REDIS_CONFIG[:port])

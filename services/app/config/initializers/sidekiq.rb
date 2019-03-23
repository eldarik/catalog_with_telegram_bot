redis_conn = proc {
  Redis.new(
    url: Rails.application.secrets.redis_url,
    connect_timeout: 5,
    timeout: 5,
  )
}

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: Rails.application.secrets.redis_conn_pool_client_size.to_i, &redis_conn)
end

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: Rails.application.secrets.redis_conn_pool_server_size.to_i, &redis_conn)
end


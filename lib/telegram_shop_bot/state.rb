class TelegramShopBot::State
  attr_accessor :state, :redis_connection

  def initialize(user_id:)
    @redis_connection = Redis.new
    @state = JSON.parse(redis_connection.get(user)) rescue nil
  end

  def update(page:, order:)
    @state[:previous_page]= @state[:current_page]
    @state[:order]= order
  end

end

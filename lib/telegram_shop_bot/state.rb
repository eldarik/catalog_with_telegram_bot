class TelegramShopBot::State
  attr_accessor :state, :redis_connection

  def initialize(user_id:)
    @redis_connection = Redis.new
    @state = JSON.parse(redis_connection.get(user)) rescue {}
  end

  def update(args)
    @state[:previous_page] = @state[:current_page]
    @state[:current_page] = args[:page]
    @state[:page_options] = args[:page_options]
    @state[:order]= args[:order]
  end

end

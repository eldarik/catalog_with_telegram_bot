class TelegramShopBot::State
  attr_accessor :value, :redis_connection, :user_id

  def initialize(user_id:)
    @user_id = user_id
    @redis_connection = Redis.new
    @value = JSON.parse(redis_connection.get(user_id)).with_indifferent_access rescue {}
  end

  def update(args)
    if args[:page].present?
      @value[:previous_page] = @value[:current_page]
      @value[:current_page] = args[:page]
    end
    @value[:page_options] = args[:page_options]
    unless args[:order].nil?
      @value[:order]= args[:order]
    end
    redis_connection.set(user_id, value.to_json)
  end

end

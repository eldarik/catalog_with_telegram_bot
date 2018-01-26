class TelegramShopBot::State
  attr_accessor :state, :redis_connection, :user_id

  def initialize(user_id:)
    @user_id = user_id
    @redis_connection = Redis.new
    @state = JSON.parse(redis_connection.get(user_id)).with_indifferent_access rescue {}
  end

  def update(args)
    if args[:page].present?
      @state[:previous_page] = @state[:current_page]
      @state[:current_page] = args[:page]
    end
    if args[:page_options].present?
      @state[:page_options] = args[:page_options]
    end
    if args[:order].present?
      @state[:order]= args[:order]
    end
    redis_connection.set(user_id, state.to_json)
  end

end

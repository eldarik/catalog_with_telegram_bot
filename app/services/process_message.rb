require 'telegram/bot'

class ProcessMessage < Service

  def call(args)
    @bot = ::Telegram::Bot::Client.new(Rails.application.secrets.tg_bot_token)
    @message = args[:message]
    @state = TelegramShopBot::State.new(user_id: message[:user_id])
    process
  end

  private
  attr_accessor :message, :state

  def process
    case message[:type]
    when 'Telegram::Bot::Types::Message'
      process_basic_message
    when 'Telegram::Bot::Types::CallbackQuery'
      process_callback_query
    end
  end

  def process_basic_message
    case message[:text]
    when '/start'
      process_start_page
    when '/main'
      process_main_page
    else
      save_contact_information
      process_main_page
    end
  end

  def save_contact_information
    if message[:contact].present?
      Client.find_or_initialize_by(telegram_uid: message[:user_id])
            .update(message[:contact].slice(:phone_number, :first_name, :last_name))
    end
  end

  def process_callback_query
    case message[:data]
    when 'search'
      process_search_page
    end
  end

  def process_start_page
    state.update(page: 'start')
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Start.new(bot: bot, recipient_id: message[:recipient_id]).render_for_recipient
    end
  end

  def process_search_page
    state.update(page: 'search')
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Search.new(bot: bot, recipient_id: message[:recipient_id]).render_for_recipient
    end
  end

  def process_main_page
    state.update(page: 'main')
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Main.new(bot: bot, recipient_id: message[:recipient_id]).render_for_recipient
    end
  end

end

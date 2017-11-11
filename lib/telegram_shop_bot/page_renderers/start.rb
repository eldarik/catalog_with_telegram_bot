class TelegramShopBot::PageRenderers::Start < TelegramShopBot::PageRenderers::Base

  def initialize(args)
    @bot = args[:bot]
    raise 'bot is required' unless bot.present?
    @receipent_id = args[:receipent_id]
    raise 'receipent_id is required' unless receipent_id.present?
  end

  def render_for_receipent
    render_request_of_phone_number
  end

  private
  def render_request_of_phone_number
    keyboard = Telegram::Bot::Types::KeyboardButton.new(text: 'разрешить', request_contact: true),
    markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
    bot.api.send_message(
      chat_id: receipent.id, text: 'доступ к номеру телефона', reply_markup: markup
    )
  end
end

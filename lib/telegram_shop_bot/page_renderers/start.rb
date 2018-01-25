class TelegramShopBot::PageRenderers::Start < TelegramShopBot::PageRenderers::Base

  def render_for_recipient
    render_request_of_phone_number
  end

  private
  def render_request_of_phone_number
    keyboard = Telegram::Bot::Types::KeyboardButton.new(text: 'разрешить', request_contact: true)
    markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: keyboard)
    bot.api.send_message(
      chat_id: chat_id, text: 'доступ к номеру телефона', reply_markup: markup
    )
  end
end

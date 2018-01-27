class TelegramShopBot::PageRenderers::Base
  attr_accessor :text_messages, :keyboard, :images
  attr_reader :bot, :recipient_id

  def initialize(args)
    @bot = args[:bot]
    raise 'bot is required' unless bot.present?
    @recipient_id = args[:recipient_id]
    raise 'recipient_id is required' unless recipient_id.present?

    unless args[:without_buttons]
      initialize_keyboard(args[:keyboard_buttons])
    end
    initialize_images(args[:image_paths])
    @text_messages = args[:text_messages]
  end

  def render_for_recipient
    render_text_messages
    render_images
    render_keyboard
  end

  private
  def render_images
    images&.each do |image|
      bot.api.send_photo(chat_id: recipient_id, photo: image)
    end
  end

  def render_text_messages
    text_messages&.each do |m|
      bot.api.send_message(chat_id: recipient_id, text: m)
    end
  end

  def render_keyboard
    if keyboard.present?
      bot.api.send_message(chat_id: recipient_id, text: 'Выбирете дальнейшее действие', reply_markup: keyboard)
    end
  end

  def initialize_keyboard(keyboard_buttons)
    if keyboard_buttons.present?
      buttons =
        keyboard_buttons.map do |b|
          Telegram::Bot::Types::InlineKeyboardButton.new(b.slice(:text, :callback_data))
        end
      @keyboard =
        markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: buttons)
    end
  end

  def initialize_images(image_paths)
    @images = image_paths&.compact.map { |i| Faraday::UploadIO.new(i, 'image/jpeg') }
  end

end

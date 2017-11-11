class TelegramShopBot::PageRenderers::Base
  attr_accessor :text_messages, :keyboard, :images
  attr_reader :bot, :receipent_id

  def initialize(args)
    @bot = args[:bot]
    raise 'bot is required' unless bot.present?
    @receipent_id = args[:receipent_id]
    raise 'receipent_id is required' unless receipent_id.present?

    initialize_keyboard(args[:keyboard_buttons])
    initialize_images(args[:image_paths])
    @text_messages = args[:text_messages]
  end

  def render_for_receipent
    send_images
    send_text_messages
    send_keyboard
  end

  private
  def render_images
    images&.each do |image|
      bot.api.send_photo(chat_id: receipent_id, photo: image)
    end
  end

  def render_text_messages
    text_messages&.each do |m|
      bot.api.send_message(chat_id: receipent_id, text: m)
    end
  end

  def render_keyboard
    bot.api.send_message(chat_id: receipent_id, text: '_', reply_markup: keyboard)
  end

  def initialize_keyboard(keyboard_buttons)
    buttons =
      keyboard_buttons.map do |b|
        Telegram::Bot::Types::InlineKeyboardButton.new(b.slice(:text, :callback_data)
      end
    @keyboard =
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: buttons)
  end

  def initialize_images(image_paths)
    @images = image_paths&.map { |i| Faraday::UploadIO.new(i, 'image/jpeg')
  end

end

class TelegramShopBot::PageRenderers::Start < TelegramShopBot::PageRenderers::Base

  def initialize(args)
    @bot = args[:bot]
    raise 'bot is required' unless bot.present?
    @receipent_id = args[:receipent_id]
    raise 'receipent_id is required' unless receipent_id.present?

    initialize_keyboard(args[:keyboard_buttons])
  end
end

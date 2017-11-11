class TelegramShopBot::PageRenderers::Main < TelegramShopBot::PageRenderers::Base

  def initialize(args)
    args[:keyboard_buttons] = [
      { text: 'поиск', callback_data: 'search' },
      { text: 'разделы', callback_data: 'departments' },
      { text: 'категории', callback_data: 'categories' }
    ]
    super
  end

end

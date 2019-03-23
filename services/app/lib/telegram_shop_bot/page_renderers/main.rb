class TelegramShopBot::PageRenderers::Main < TelegramShopBot::PageRenderers::Base

  def initialize(args)
    args[:keyboard_buttons] = [
      { text: 'поиск', callback_data: 'search' },
      { text: 'разделы', callback_data: 'departments' },
      { text: 'категории', callback_data: 'categories' },
      { text: 'корзина', callback_data: 'current_order' },
      { text: 'мои заказы', callback_data: 'orders' }
    ]
    super
  end

end

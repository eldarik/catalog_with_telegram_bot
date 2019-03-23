class TelegramShopBot::PageRenderers::Categories < TelegramShopBot::PageRenderers::Base

  def initialize(args)
    raise 'categories are required' unless args[:categories].present?
    args[:keyboard_buttons] = generate_keyboard_buttons(args[:categories])
    super
  end

  private
  def generate_keyboard_buttons(categories)
    categories.map { |d| { text: d.name, callback_data: "categories/#{d.id}" } }
  end

end

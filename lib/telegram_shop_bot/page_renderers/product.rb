class TelegramShopBot::PageRenderers::Product < TelegramShopBot::PageRenderers::Base
  attr_accessor :product
  def initialize(args)
    @product = args[:product]
    args[:image_paths] = get_image_paths
    args[:text_messages] ||= generate_text_messages
    args[:keyboard_buttons] ||= generate_keyboard_buttons
    super
  end

  private
  def get_image_paths
    #todo add images to products
    []
  end

  def generate_keyboard_buttons
    [
      { text: 'подробнее', callback_data: "products/#{product.id}" },
      { text: 'добавить к заказу', callback_data: "products/#{product.id}/add_to_order" }
    ]
  end

  def generate_text_messages
    [
      product.name,
      "Описание: \n#{product.description.split('.').first(2).join}."
    ]
  end
end

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
    [cache_image(product.images.first)]
  end

  def cache_image(image)
    service_result =
      DownloadImageFromCloudinary.call(
        upload: image, options_for_image: { width: 185, height: 74, crop: :fit }
      )
    service_result.success? ? service_result.data[:file_path].to_s : nil
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

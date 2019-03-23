class TelegramShopBot::PageRenderers::AddProduct < TelegramShopBot::PageRenderers::Base
  attr_accessor :product
  def initialize(args)
    @product = args[:product]
    args[:text_messages] ||= generate_text_messages
    super
  end

  private

  def generate_text_messages
    [
      product.name,
      "укажите количество"
    ]
  end
end

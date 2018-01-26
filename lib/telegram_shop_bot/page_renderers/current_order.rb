class TelegramShopBot::PageRenderers::CurrentOrder < TelegramShopBot::PageRenderers::Base
  attr_accessor :order

  def initialize(args)
    @order = args[:order]
    if order.present?
      args[:text_messages] = [
        ::Product.find(args['product_id']).name,
        "количество #{args['count']}"
      ]
      args[:keyboard_buttons] = [
        { text: 'удалить', callback_data: "products/#{args['product_id']}/remove_from_order" }
      ]
    else
      args[:text_messages] = ['ваша корзина пуста']
    end

    super
  end
end

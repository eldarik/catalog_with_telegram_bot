class TelegramShopBot::PageRenderers::CurrentOrder < TelegramShopBot::PageRenderers::Base
  attr_accessor :order

  def initialize(args)
    @order = args[:order]
    super
  end

  def render_for_recipient
    if order.present?
      order.each do |product|
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: recipient_id,
          text_messages: [
            ::Product.find(product['product_id']).name,
            "количество #{product['count']}"
          ],
          keyboard_buttons: [
            { text: 'удалить', callback_data: "products/#{product['product_id']}/remove_from_order" }
          ]
        ).render_for_recipient
      end
    else
      TelegramShopBot::PageRenderers::Base.new(
        bot: bot, recipient_id: recipient_id,
        text_messages: [ "ваша корзина пуста" ]
      )
    end
  end
end

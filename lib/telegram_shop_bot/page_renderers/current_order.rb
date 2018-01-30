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
      TelegramShopBot::PageRenderers::Base.new(
        bot: bot, recipient_id: recipient_id,
        keyboard_buttons: [
          { text: 'сохранить заказ', callback_data: "save_current_order" }
        ]
      ).render_for_recipient
    else
      TelegramShopBot::PageRenderers::Base.new(
        bot: bot, recipient_id: recipient_id,
        text_messages: [ "ваша корзина пуста" ]
      ).render_for_recipient
    end
  end
end

class TelegramShopBot::PageRenderers::CurrentOrder < TelegramShopBot::PageRenderers::Base
  attr_accessor :order

  def initialize(args)
    @order = args[:order]
    super
  end

  def render
    if order.present?
      total = 0.0
      order.each do |product_attr|
        product = ::Product.find(product_attr['product_id'])
        sum = product.price * product_attr['count'].to_i
        total += sum
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: recipient_id,
          text_messages: [
            product.name,
            "количество #{product_attr['count']}",
            "на сумму: #{sum}"
          ],
          keyboard_buttons: [
            { text: 'удалить', callback_data: "products/#{product.id}/remove_from_order" }
          ]
        ).render
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: recipient_id,
          text_messages: [
            "Общая сумма заказа: #{total}"
          ]
        ).render
      end
      TelegramShopBot::PageRenderers::Base.new(
        bot: bot, recipient_id: recipient_id,
        keyboard_buttons: [
          { text: 'сохранить заказ', callback_data: "save_current_order" }
        ]
      ).render
    else
      TelegramShopBot::PageRenderers::Base.new(
        bot: bot, recipient_id: recipient_id,
        text_messages: [ "ваша корзина пуста" ]
      ).render
    end
  end
end

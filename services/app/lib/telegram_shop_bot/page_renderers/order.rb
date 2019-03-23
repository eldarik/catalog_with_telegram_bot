class TelegramShopBot::PageRenderers::Order < TelegramShopBot::PageRenderers::Base
  attr_accessor :order

  def initialize(args)
    @order = args[:order]

    args[:text_messages] ||= generate_text_messages
    args[:keyboard_buttons] ||= generate_keyboard_buttons

    super
  end

  private

  def generate_text_messages
    msgs = ["заказ №#{order.id}"]
    msgs |= order.order_elements.map do |order_element|
      sum = order_element.product.price * order_element.count
      "#{order_element.product.name}, #{order_element.count} шт., #{sum}"
    end
    msgs << "Общая сумма заказа: #{order.total}"
    msgs
  end

  def generate_keyboard_buttons
    [
      { text: 'отменить', callback_data: "orders/#{order.id}/remove" }
    ]
  end
end

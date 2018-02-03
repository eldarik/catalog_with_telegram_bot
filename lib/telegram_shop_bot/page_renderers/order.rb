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
      total = 0.0
    msgs |= order.includes(:order_elements, :products).order_elements.map do |order_element|
      sum = order_element.product.price * order_element.count
      total += sum
      "#{order_element.product.name}, #{order_element.count} шт., #{sum}"
    end
    msgs |= "Общая сумма заказа: #{total}"
    msgs
  end

  def generate_keyboard_buttons
    [
      { text: 'отменить', callback_data: "orders/#{order.id}/remove" }
    ]
  end
end

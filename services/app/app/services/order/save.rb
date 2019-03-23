class Order::Save < Service

  def call(args)
    @order_attrs = args[:order_attrs]

    build_order

    if order.save
      result.success!
    else
      result.failed!
    end

    result
  end

  private
  attr_accessor :order_attrs, :order

  def build_order
    @order = Order.new(client_id: order_attrs[:client_id])
    total = 0.0
    order_attrs[:products].each do |product|
      order_element = @order.order_elements.new(product)
      total += order_element.count * order_element.product.price
    end
    @order.total = total
  end
end

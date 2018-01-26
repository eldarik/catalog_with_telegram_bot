class TelegramShopBot::PageRenderers::CurrentOrder < TelegramShopBot::PageRenderers::Base
  attr_accessor :order
  def initialize(args)
    @order = args[:order]
    order.each do |product|
      render_product(args.merge(product))
    end
    super
  end

  private

  def render_product(args)
    TelegramShopBot::PageRenderers::Base.new(
      args.merge(
        text_messages: [
          ::Product.find(args['product_id']).name,
          "количество #{args['count']}"
        ],
        keyboard_buttons: [
          { text: 'удалить', callback_data: "products/#{args['product_id']}/remove_from_order" },
          #todo add update count
        ]
      )
    ).render_for_recipient
  end
end

module ProcessMessage::Pages

  def departments_page
    current_state.update(page: 'departments')
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Departments.new(
        bot: bot, recipient_id: message[:user_id], departments: Department.all
      ).render
    end
  end

  def categories_page(args = {})
    department_id = args[:department_id]
    categories = if department_id.present?
                   Department.find(department_id).categories
                 else
                   Category.all
                 end
    current_state.update(page: 'categories')
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Categories.new(
        bot: bot, recipient_id: message[:user_id], categories: categories
      ).render
    end
  end

  def products_page(args = {})
    category_id = args[:category_id] || current_state.value.dig(:page_options, :category_id)
    term = args[:term] || current_state.value.dig(:page_options, :term)
    current_page_number = (current_state.value.dig(:page_options, :page_number) || 0) + 1
    products = if category_id.present?
                 Category.find(category_id).products
               elsif term.present?
                 Product.search(term)
               else
                 Product.all
               end.page(current_page_number).per(3)
    @bot.run do |bot|
      if products.present?
        current_state.update(
          page: 'products',
          page_options: {
            category_id: category_id,
            term: term,
            page_number: (current_state.value.dig(:page_options, :page_number) || 0) + 1
          }
        )
        products.each do |product|
          TelegramShopBot::PageRenderers::Product.new(
            bot: bot, recipient_id: message[:user_id], product: product
          ).render
        end
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: message[:user_id],
          keyboard_buttons: [
            { text: 'следующие', callback_data: "products_next" }
          ]
        ).render
      else
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: message[:user_id],
          text_messages: ['ничего не найдено, попробуйте найти что-нибудь другое']
        ).render
      end
    end
  end

  def start_page
    current_state.update(page: 'start')
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Start.new(
        bot: bot, recipient_id: message[:user_id]
      ).render
    end
  end

  def search_page
    current_state.update(page: 'search')
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Search.new(
        bot: bot, recipient_id: message[:user_id]
      ).render
    end
  end

  def main_page
    current_state.update(page: 'main')
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Main.new(
        bot: bot, recipient_id: message[:user_id]
      ).render
    end
  end

  def product_page(product_id:)
    current_state.update(page: "products/#{product_id}")
    product = Product.find(product_id)
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::DetailedProduct.new(
        bot: bot, recipient_id: message[:user_id], product: product
      ).render
    end
  end

  def current_order_page
    current_state.update(page: "current_order")
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::CurrentOrder.new(
        bot: bot, recipient_id: message[:user_id], order: current_state.value[:order]
      ).render
    end
  end

  def orders_page
    orders = Client.find_by(telegram_uid: message[:user_id])&.orders&.includes(:order_elements, :products)
    @bot.run do |bot|
      if orders.present?
        orders.each do |order|
          TelegramShopBot::PageRenderers::Order.new(
            bot: bot, recipient_id: message[:user_id], order: order
          ).render
        end
      else
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: message[:user_id],
          text_messages: ['нет сохраненных заказов']
        ).render
      end
    end
  end

end

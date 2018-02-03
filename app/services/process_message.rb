require 'telegram/bot'

class ProcessMessage < Service

  def call(args)
    @bot = ::Telegram::Bot::Client.new(Rails.application.secrets.tg_bot_token)
    @message = args[:message]
    @current_state = TelegramShopBot::State.new(user_id: message[:user_id])
    process
  end

  private
  attr_accessor :message, :current_state

  def process
    case message[:type]
    when 'Telegram::Bot::Types::Message'
      process_basic_message
    when 'Telegram::Bot::Types::CallbackQuery'
      process_callback_query
    end
  end

  def process_basic_message
    case message[:text]
    when '/start'
      start_page
    when '/main'
      main_page
    else
      case current_state.value[:current_page]
      when 'search'
        products_page(term: message[:text])
      else
        if current_state.value[:current_page] =~ /products\/(\d+)\/add_to_order/
          add_product_to_order(product_id: $1, count: message[:text])
        else
          save_contact_information
          main_page
        end
      end
    end
  end

  def save_contact_information
    if message[:contact].present?
      Client.find_or_initialize_by(telegram_uid: message[:user_id])
            .update(message[:contact].slice(:phone_number, :first_name, :last_name))
    end
  end

  def process_callback_query
    case message[:data]
    when 'search'
      search_page
    when 'departments'
      departments_page
    when 'categories'
      categories_page
    when 'current_order'
      current_order_page
    when 'save_current_order'
      save_current_order
    when 'orders'
      orders_page
    when /departments\/(\d+)/
      categories_page(department_id: $1)
    when /products_next/
      products_page
    when /categories\/(\d+)/
      products_page(category_id: $1)
    when /products\/(\d+)\z/
      product_page(product_id: $1)
    when /products\/(\d+)\/add_to_order/
      add_to_order(product_id: $1)
    when /products\/(\d+)\/remove_from_order/
      remove_from_order(product_id: $1)
    when /orders\/(\d+)\/remove/
      remove_order(order_id: $1)
    end
  end

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

  def add_to_order(product_id:)
    product = Product.find(product_id)
    current_state.update(page: "products/#{product_id}/add_to_order")
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::AddProduct.new(
        bot: bot, recipient_id: message[:user_id], product: product
      ).render
    end
  end

  def add_product_to_order(product_id:, count:)
    @bot.run do |bot|
      if count.to_i < 1
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: message[:user_id],
          text_messages: ['пожалуйста, укажите количество больше 0']
        ).render
      else
        current_order = current_state.value[:order] || []
        current_order << { product_id: product_id, count: count.to_i }
        current_state.update(order: current_order)
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: message[:user_id], text_messages: ['добавлен']
        ).render
        main_page
      end
    end
  end

  def save_current_order
    service_result =
      Order::Save.call(
        order_attrs: {
          client_id: Client.find_by(telegram_uid: message[:user_id])&.id,
          products: current_state.value[:order]
        }
      )

    if service_result.success?
      @bot.run do |bot|
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: message[:user_id],
          text_messages: ['ваш заказ сохранен']
        ).render
      end
    end
  end

  def remove_from_order(product_id:)
    current_order = current_state.value[:order]
    current_order = current_order.reject { |p| p['product_id'].to_i == product_id.to_i }
    current_state.update(order: current_order)
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Base.new(
        bot: bot, recipient_id: message[:user_id], text_messages: ['удален']
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

  def remove_order(order_id:)
    order = Client.find_by(telegram_uid: message[:user_id])&.orders&.find(order_id)
    order.destroy
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Base.new(
        bot: bot, recipient_id: message[:user_id],
        text_messages: ['заказ отменен']
      ).render
    end
  end
end

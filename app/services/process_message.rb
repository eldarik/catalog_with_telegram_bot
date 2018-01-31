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
      process_start_page
    when '/main'
      process_main_page
    else
      case current_state.value[:current_page]
      when 'search'
        process_products_page(term: message[:text])
      else
        if current_state.value[:current_page] =~ /products\/(\d+)\/add_to_order/
          add_product_to_order(product_id: $1, count: message[:text])
        else
          save_contact_information
          process_main_page
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
      process_search_page
    when 'departments'
      process_departments_page
    when 'categories'
      process_categories_page
    when 'current_order'
      process_current_order_page
    when 'save_current_order'
      process_save_current_order
    when 'orders'
      process_orders_page
    else
      if message[:data] =~ /departments\/(\d+)/
        process_categories_page(department_id: $1)
      elsif message[:data] =~ /products_next/
        process_products_page
      elsif message[:data] =~ /categories\/(\d+)/
        process_products_page(category_id: $1)
      elsif message[:data] =~ /products\/(\d+)\z/
        process_product_page(product_id: $1)
      elsif message[:data] =~ /products\/(\d+)\/add_to_order/
        process_add_to_order(product_id: $1)
      elsif message[:data] =~ /products\/(\d+)\/remove_from_order/
        process_remove_from_order(product_id: $1)
      end
    end
  end

  def process_departments_page
    current_state.update(page: 'departments')
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Departments.new(
        bot: bot, recipient_id: message[:user_id], departments: Department.all
      ).render_for_recipient
    end
  end

  def process_categories_page(args = {})
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
      ).render_for_recipient
    end
  end

  def process_products_page(args = {})
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
          ).render_for_recipient
        end
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: message[:user_id],
          keyboard_buttons: [
            { text: 'следующие', callback_data: "products_next" }
          ]
        ).render_for_recipient
      else
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: message[:user_id],
          text_messages: ['ничего не найдено, попробуйте найти что-нибудь другое']
        ).render_for_recipient
      end
    end
  end

  def process_start_page
    current_state.update(page: 'start')
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Start.new(
        bot: bot, recipient_id: message[:user_id]
      ).render_for_recipient
    end
  end

  def process_search_page
    current_state.update(page: 'search')
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Search.new(
        bot: bot, recipient_id: message[:user_id]
      ).render_for_recipient
    end
  end

  def process_main_page
    current_state.update(page: 'main')
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Main.new(
        bot: bot, recipient_id: message[:user_id]
      ).render_for_recipient
    end
  end

  def process_product_page(product_id:)
    current_state.update(page: "products/#{product_id}")
    product = Product.find(product_id)
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::DetailedProduct.new(
        bot: bot, recipient_id: message[:user_id], product: product
      ).render_for_recipient
    end
  end

  def process_current_order_page
    current_state.update(page: "current_order")
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::CurrentOrder.new(
        bot: bot, recipient_id: message[:user_id], order: current_state.value[:order]
      ).render_for_recipient
    end
  end

  def process_add_to_order(product_id:)
    product = Product.find(product_id)
    current_state.update(page: "products/#{product_id}/add_to_order")
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::AddProduct.new(
        bot: bot, recipient_id: message[:user_id], product: product
      ).render_for_recipient
    end
  end

  def add_product_to_order(product_id:, count:)
    @bot.run do |bot|
      if count.to_i < 1
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: message[:user_id],
          text_messages: ['пожалуйста, укажите количество больше 0']
        ).render_for_recipient
      else
        current_order = current_state.value[:order] || []
        current_order << { product_id: product_id, count: count.to_i }
        current_state.update(order: current_order)
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: message[:user_id], text_messages: ['добавлен']
        ).render_for_recipient
        process_main_page
      end
    end
  end

  def process_save_current_order
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
        ).render_for_recipient
      end
    end
  end

  def process_remove_from_order(product_id:)
    current_order = current_state.value[:order]
    current_order = current_order.reject { |p| p['product_id'].to_i == product_id.to_i }
    current_state.update(order: current_order)
    @bot.run do |bot|
      TelegramShopBot::PageRenderers::Base.new(
        bot: bot, recipient_id: message[:user_id], text_messages: ['удален']
      ).render_for_recipient
    end
  end

  def process_orders_page
    orders = Client.find_by(telegram_uid: message[:user_id])&.orders&.includes(:order_elements, :products)
    @bot.run do |bot|
      if orders.present?
        orders.each do |order|
          TelegramShopBot::PageRenderers::Order.new(
            bot: bot, recipient_id: message[:user_id], order: order
          ).render_for_recipient
        end
      else
        TelegramShopBot::PageRenderers::Base.new(
          bot: bot, recipient_id: message[:user_id],
          text_messages: ['нет сохраненных заказов']
        ).render_for_recipient
      end
    end
  end
end

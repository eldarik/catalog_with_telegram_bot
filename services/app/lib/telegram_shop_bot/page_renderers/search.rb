class TelegramShopBot::PageRenderers::Search < TelegramShopBot::PageRenderers::Base
  def initialize(args)
    args[:text_messages] = ['Отправьте следующим сообщением то, что хотите найти']
    super
  end
end

class TelegramShopBot::PageRenderers::Departments < TelegramShopBot::PageRenderers::Base

  def initialize(args)
    raise 'departments are required' unless args[:departments].present?
    args[:keyboard_buttons] = generate_keyboard_buttons(args[:departments])
    super
  end

  private
  def generate_keyboard_buttons(departments)
    departments.map { |d| { text: d.name, callback_data: "departments/#{d.id}" } }
  end

end

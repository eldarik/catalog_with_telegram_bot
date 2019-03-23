Rails.application.configure do
  config.bot_pages = YAML.load_file(Rails.root.join('config', 'bot_pages.yml'))
end

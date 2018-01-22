class ProcessMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    puts message
  end
end

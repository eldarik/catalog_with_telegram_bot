class ProcessMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    ProcessMessage.call(message)
  end

end

class Service
  class Result
    attr_reader :data

    def initialize
      @data = {}
    end

    def success?
      @success
    end

    def success!
      @success = true
    end

    def failed!
      @success = false
    end
  end

  attr_reader :result

  class << self
    def call(params = {})
      new.call(params)

    rescue => error
      result_with_error(error)
    end

    def call_later(params = {}, delay = nil)
      if delay.present?
        ServiceJob.set(wait: delay).perform_later(self.to_s, params)
      else
        ServiceJob.perform_later(self.to_s, params)
      end
    end

    def result_with_error(error)
      log_exception(error)

      result = Result.new
      result.failed!
      result.data[:errors] = { error.class.name.delete('::').underscore => [error.message] }
      result
    end

    def log_exception(ex)
      Rails.logger.error ex.inspect
      Rails.logger.error ex.backtrace.join("\n")
    end
  end

  def initialize
    @result = Result.new
  end

  def call(params)
    raise 'Not implemented error'
  end
end

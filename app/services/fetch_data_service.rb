# frozen_string_literal: true

class FetchDataService
  include Ultilities::Redis

  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def call
    fetch_data_from_redis(current_page)
  rescue StandardError => e
    Rails.logger.error e.message
    {}
  end

  private

  def current_page
    params[:page].to_i + 1
  end
end

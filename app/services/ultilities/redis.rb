# frozen_string_literal: true

module Ultilities::Redis
  private

  def fetch_data_from_redis(page)
    data = $redis.get "#{Settings.redis.key.article}_#{page}" # rubocop:disable Style/GlobalVars

    data.present? ? JSON.parse(data) : nil
  end

  def save_data_to_redis(data, page)
    $redis.set "#{Settings.redis.key.article}_#{page}", data.to_json # rubocop:disable Style/GlobalVars
  end

  def clear_cache(page)
    $redis.del "#{Settings.redis.key.article}_#{page}" # rubocop:disable Style/GlobalVars
  end
end

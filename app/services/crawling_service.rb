# frozen_string_literal: true

class CrawlingService
  include Ultilities::Redis

  def call
    crawler_news(1)
  end

  private

  def crawler_news(current_page)
    Rails.logger.info ">>>>> Current Page #{current_page}"

    # Clear cache of each page
    Rails.logger.info ">>>>> Clear cache: #{current_page}"
    clear_cache current_page

    # Get data of current page
    data = Crawling::ListService.new(current_page).call
    # Save to redis with key is: `Setting-page`
    save_data_to_redis(data, current_page)

    # If the response has next page -> run next
    if data[:next_page].present?
      Rails.logger.info ">>>> Run to next page #{data[:next_page]}"

      crawler_news(data[:next_page])
    end

    true
  end
end

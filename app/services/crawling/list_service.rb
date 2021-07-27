# frozen_string_literal: true

require 'nokogiri'

module Crawling
  class ListService
    attr_accessor :articles, :current_page, :next_page

    def initialize(current_page)
      @current_page = current_page
    end

    def call
      @articles = fetch_articles

      build_data
    rescue StandardError => e
      Rails.logger.error e.message
      {}
    end

    private

    def build_data
      {
        articles: @articles || [],
        pre_page: pre_page,
        current_page: current_page,
        next_page: @next_page
      }
    end

    def pre_page
      return nil if current_page > 1

      current_page - 1
    end

    # Fetch and parse HTML document
    def fetch_articles # rubocop:disable Metrics/AbcSize
      doc = Nokogiri::HTML(response.body)
      next_page_link = doc.css('table.itemlist tr td.title a.morelink')&.first&.attribute('href')&.value
      @next_page = next_page_link.present? ? next_page_link.scan(/\d/).last.to_i : nil

      doc.css('table.itemlist tr.athing').each.map do |content|
        build_item(content)
      end.compact
    end

    def build_item(content) # rubocop:disable Metrics/PerceivedComplexity, Metrics/AbcSize
      link = content.search('td.title a.storylink')&.first&.attribute('href')&.value || ''
      item = fetch_item(link)
      return if item.empty?

      source_name = content.search('td.title span.comhead span.sitestr')&.first&.content || ''
      attr = {
        id: content.attribute('id').value.to_i,
        title: content.search('td.title a.storylink')&.first&.content.presence || '',
        link: link,
        source_name: source_name,
        author: content.next_element.search('td.subtext a.hnuser')&.first&.content || '',
        image: format_image_link(item[:image], source_name),
        short_content: item[:short_content],
        content: item[:content]
      }

      Article.new(attr)
    end

    def fetch_item(link)
      Crawling::ItemService.new(link).call
    end

    def response
      options = current_page > 1 ? { p: current_page } : {}
      HTTParty.get(Settings.target.url, query: options)
    rescue StandardError => e
      Rails.logger.error e.message
      nil
    end

    def format_image_link(link, source_name)
      return link if link.match?("^(http|https):\/\/")

      "https://#{source_name}/#{link}"
    end
  end
end

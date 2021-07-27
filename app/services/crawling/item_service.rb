# frozen_string_literal: true

require 'rubygems'
require 'readability'
require 'nokogiri'

# https://tenthousandmeters.com/blog/python-behind-the-scenes-11-how-the-python-import-system-works/
module Crawling
  class ItemService
    attr_accessor :link, :data

    HTML_TAGS = %w[a abbr acronym address applet area article aside audio b base basefont bdi bdo bgsound big blink
                   blockquote body br button canvas caption center cite code col colgroup content data datalist dd
                   decorator del details dfn dir div dl dt element em embed fieldset figcaption figure font footer
                   form frame frameset h1 h2 h3 h4 h5 h6 head header hgroup hr html i iframe img input ins isindex
                   kbd keygen label legend li link listing main map mark marquee menu menuitem meta meter nav nobr
                   noframes noscript object ol optgroup option output p param plaintext pre progress q rp rt ruby s
                   samp script section select shadow small source spacer span strike strong style sub summary sup table
                   tbody td template textarea tfoot th thead time title tr track tt u ul var video wbr xmp].freeze

    def initialize(link = '')
      @link = link
      @data = {}
    end

    def call
      parse_content if link.present?
      data
    rescue StandardError => e
      Rails.logger.error e.message
      data
    end

    private

    def parse_content # rubocop:disable Metrics/AbcSize
      return if response.nil?

      content = rbody.content
      short_content = Nokogiri::HTML(content).text.gsub(/[\r\n\t\s]+/, ' ')

      data[:content] = content
      data[:short_content] = short_content.truncate(Settings.article.short_content.length, separator: /\s/)
      data[:image] = fetch_images.first
    end

    def fetch_images
      rbody.images.presence || ["#{Settings.base_url}#{ActionController::Base.helpers.asset_url('no-image.png')}"]
    end

    def rbody
      @rbody ||= Readability::Document.new(response,
                                           tags: HTML_TAGS,
                                           attributes: %w[src href id class alt width height],
                                           remove_empty_nodes: false)
    end

    def response
      @response ||= begin
        HTTParty.get(link, query: {})
      rescue StandardError => e
        Rails.logger.error e.message
        nil
      end
    end
  end
end

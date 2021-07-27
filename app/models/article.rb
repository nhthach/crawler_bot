# frozen_string_literal: true

class Article
  include ActiveModel::Model

  attr_accessor :id, :title, :link, :image, :short_content, :content,
                :author, :source_link, :source_name
end

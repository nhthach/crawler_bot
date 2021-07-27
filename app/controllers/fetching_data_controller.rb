# frozen_string_literal: true

class FetchingDataController < ApplicationController
  def data_stream
    results = FetchDataService.new(params).call
    render json: results.to_json, status: :ok
  end
end

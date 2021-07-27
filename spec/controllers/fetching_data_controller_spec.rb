# frozen_string_literal: true

require "rails_helper"

def json_response
  JSON.parse(response.body, symbolize_names: true)
end

RSpec.describe FetchingDataController, type: :controller do
  let(:mock_cache_data) {  RedisCacheStubData.data }

  describe "#data_stream" do
    context "success" do
      before do
        allow_any_instance_of(FetchDataService).to receive(:fetch_data_from_redis).and_return(mock_cache_data)
        get :data_stream, params: {page: 0}
      end

      it "render json with success = true and right data" do
        expect(response).to	have_http_status "200"
        expect(json_response).to eq mock_cache_data
      end
    end
  end
end

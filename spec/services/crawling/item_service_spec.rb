# frozen_string_literal: true

require "rails_helper"

RSpec.describe Crawling::ItemService, type: :service do

  let(:hosting_response) { instance_double(HTTParty::Response, body: "Response body") }
  let(:service) { described_class.new("https:example.com") }

  describe "success" do
    before do
      allow(HTTParty).to receive(:get).and_return(hosting_response)
    end

    context "get data" do

      shared_examples "return right keys" do
        it do
          expect(@result.keys).to eq [:content, :short_content, :image]
        end
      end

      context "images has value" do
        let(:mock_http_response) {
          {
            content: "A" * (Settings.article.short_content.length + 1),
            images: ["http://example.com/images/example_1.png", "http://example.com/images/example_1.png"]
          }
        }

        before do
          allow_any_instance_of(Crawling::ItemService).to receive(:rbody).and_return(OpenStruct.new(mock_http_response))
          @result = service.call
        end

        include_examples "return right keys"
        it "should return right value" do
          expect(@result[:content]).to eq mock_http_response[:content]
          expect(@result[:short_content]).to eq "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA..."
          expect(@result[:image]).to eq mock_http_response[:images].first
        end
      end

      context "images is empty" do
        let(:mock_http_response) {
          {
            content: "A" * (Settings.article.short_content.length + 1),
            images: []
          }
        }

        before do
          allow_any_instance_of(Crawling::ItemService).to receive(:rbody).and_return(OpenStruct.new(mock_http_response))
          @result = service.call
        end

        include_examples "return right keys"
        it "should return right value" do
          expect(@result[:content]).to eq mock_http_response[:content]
          expect(@result[:short_content]).to eq "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA..."
          expect(@result[:image]).to eq "/no-image.png"
        end
      end
    end
  end

  describe "#errors" do
    context "StandardError" do
      before do
        allow_any_instance_of(Crawling::ItemService).to receive(:response).and_raise(StandardError.new("error"))
      end

      it "should raise an error and return nil" do
        expect(service.call).to eq({})
      end
    end
  end
end
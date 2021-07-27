# frozen_string_literal: true

require "rails_helper"

RSpec.describe Crawling::ListService, type: :service do

  let(:response_html) { instance_double(HTTParty::Response, body: ArticleListStubData.html_response) }
  let(:service) { described_class.new(1) }

  describe "success" do
    before do
      allow(HTTParty).to receive(:get).and_return(response_html)
    end

    context "get data" do
      shared_examples "return right keys" do
        it do
          expect(@result.keys).to eq [:articles, :pre_page, :current_page, :next_page]
          expect(@result[:pre_page]).to eq 0
          expect(@result[:current_page]).to eq 1
          expect(@result[:next_page]).to eq 2
          expect(@result[:articles].size).to eq 2
        end
      end

      let(:result) {
        [
          {"id":27926425,"title":"The Framework Laptop is now shipping","link":"https://frame.work/blog/the-framework-laptop-is-now-shipping-and-press-reviews","source_name":"frame.work","author":"ahaferburg","image":"https://example.com/image.png","short_content":"AAAA","content":"AAAA"},
          {"id":27930151,"title":"AWSs Egregious Egress","link":"https://blog.cloudflare.com/aws-egregious-egress/","source_name":"cloudflare.com","author":"jgrahamc","image":"https://example.com/image.png","short_content":"AAAA","content":"AAAA"}]
      }

      context "item can get the content" do
        let(:item_date){
          {
            content: "AAAA",
            short_content: "AAAA",
            image: "https://example.com/image.png"
          }
        }


        before do
          allow_any_instance_of(Crawling::ListService).to receive(:fetch_item).and_return(item_date)
          @result = service.call
        end

        include_examples "return right keys"
        it "should return right value" do
          expect(@result[:articles].first.title).to eq result.first[:title]
          expect(@result[:articles].first.image).to eq result.first[:image]
          expect(@result[:articles].first.link).to eq result.first[:link]
          expect(@result[:articles].first.source_name).to eq result.first[:source_name]
          expect(@result[:articles].first.short_content).to eq result.first[:short_content]
          expect(@result[:articles].first.content).to eq result.first[:content]

          expect(@result[:articles].last.title).to eq result.last[:title]
          expect(@result[:articles].last.link).to eq result.last[:link]

        end
      end

      context "special case" do
        context "image link has not protocol" do
          let(:item_date){
            {
              content: "AAAA",
              short_content: "AAAA",
              image: "asset/image.png"
            }
          }


          before do
            allow_any_instance_of(Crawling::ListService).to receive(:fetch_item).and_return(item_date)
            @result = service.call
          end

          include_examples "return right keys"
          it "should return right value" do
            expect(@result[:articles].first.title).to eq result.first[:title]
            expect(@result[:articles].last.title).to eq result.last[:title]
            expect(@result[:articles].first.link).to eq result.first[:link]
            expect(@result[:articles].last.link).to eq result.last[:link]
            expect(@result[:articles].first.image).to eq "https://frame.work/asset/image.png"
          end
        end
      end
    end
  end

  describe "#errors" do
    context "StandardError" do
      before do
        allow_any_instance_of(Crawling::ListService).to receive(:response).and_raise(StandardError.new("error"))
      end

      it "should raise an error and return nil" do
        expect(service.call).to eq({})
      end
    end
  end
end
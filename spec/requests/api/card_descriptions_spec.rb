require 'swagger_helper'

RSpec.describe 'api/cards/{card_uuid}/card_description', type: :request do
  path '/api/cards/{card_uuid}/card_description' do
    parameter name: :card_uuid, in: :path, type: :string

    get 'Shows a card description' do
      tags 'Card Descriptions'
      produces 'application/json'

      let!(:existing_card) do
        card = Card.create!(name: '打', pinyin: 'dǎ')
        CardDescription.create!(card: card, content: 'to hit')
        card
      end

      response '200', 'card description found' do
        schema '$ref' => '#/components/schemas/CardDescription'

        let(:card_uuid) { existing_card.uuid }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body['content']).to eq('to hit')
        end
      end

      response '404', 'card description not found' do
        let(:card_uuid) { Card.create!(name: '吃', pinyin: 'chī').uuid }
        run_test!
      end
    end
  end
end

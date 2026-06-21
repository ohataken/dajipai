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

    post 'Creates a card description' do
      tags 'Card Descriptions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :card_description, in: :body, schema: { '$ref' => '#/components/schemas/CardDescriptionInput' }

      let!(:existing_card) { Card.create!(name: '打', pinyin: 'dǎ') }

      response '201', 'card description created' do
        schema '$ref' => '#/components/schemas/CardDescription'

        let(:card_uuid) { existing_card.uuid }
        let(:card_description) { { card_description: { content: 'to hit' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:card_uuid) { existing_card.uuid }
        let(:card_description) { { card_description: { content: '' } } }
        run_test!
      end
    end

    put 'Updates a card description' do
      tags 'Card Descriptions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :card_description, in: :body, schema: { '$ref' => '#/components/schemas/CardDescriptionInput' }

      let!(:existing_card) do
        card = Card.create!(name: '打', pinyin: 'dǎ')
        CardDescription.create!(card: card, content: 'to hit')
        card
      end

      response '200', 'card description updated' do
        schema '$ref' => '#/components/schemas/CardDescription'

        let(:card_uuid) { existing_card.uuid }
        let(:card_description) { { card_description: { content: 'to strike' } } }
        run_test!
      end

      response '404', 'card description not found' do
        let(:card_uuid) { Card.create!(name: '吃', pinyin: 'chī').uuid }
        let(:card_description) { { card_description: { content: 'to eat' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:card_uuid) { existing_card.uuid }
        let(:card_description) { { card_description: { content: '' } } }
        run_test!
      end
    end
  end
end

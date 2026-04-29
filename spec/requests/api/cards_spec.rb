require 'swagger_helper'

RSpec.describe 'api/cards', type: :request do
  path '/api/cards' do
    get 'Lists cards' do
      tags 'Cards'
      produces 'application/json'

      response '200', 'cards listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Card' }

        before { Card.create!(name: '打', pinyin: 'dǎ') }
        run_test!
      end
    end

    post 'Creates a card' do
      tags 'Cards'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :card, in: :body, schema: { '$ref' => '#/components/schemas/CardInput' }

      response '201', 'card created' do
        schema '$ref' => '#/components/schemas/Card'

        let(:card) { { card: { name: '打', pinyin: 'dǎ' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:card) { { card: { name: '', pinyin: '' } } }
        run_test!
      end
    end
  end

  path '/api/cards/{uuid}' do
    parameter name: :uuid, in: :path, type: :string

    put 'Updates a card' do
      tags 'Cards'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :card, in: :body, schema: { '$ref' => '#/components/schemas/CardInput' }

      let(:existing_card) { Card.create!(name: '打', pinyin: 'dǎ') }

      response '200', 'card updated' do
        schema '$ref' => '#/components/schemas/Card'

        let(:uuid) { existing_card.uuid }
        let(:card) { { card: { name: '吃', pinyin: 'chī' } } }
        run_test!
      end

      response '404', 'card not found' do
        let(:uuid) { 'non-existent-uuid' }
        let(:card) { { card: { name: '吃', pinyin: 'chī' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:uuid) { existing_card.uuid }
        let(:card) { { card: { name: '', pinyin: '' } } }
        run_test!
      end
    end
  end
end

require 'swagger_helper'

RSpec.describe 'api/cards', type: :request do
  path '/api/cards' do
    get 'Lists cards' do
      tags 'Cards'
      produces 'application/json'

      response '200', 'cards listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Card' }

        before do
          card = Card.create!(name: '打', pinyin: 'dǎ')
          card.tags << Tag.create!(name: '動詞', slug: 'verbs')
        end

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body.first['tags']).to eq([ { 'slug' => 'verbs', 'name' => '動詞' } ])
        end
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
end

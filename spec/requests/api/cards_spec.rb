require 'swagger_helper'

RSpec.describe 'api/cards', type: :request do
  path '/api/cards' do
    get 'Lists cards' do
      tags 'Cards'
      produces 'application/json'

      response '200', 'cards listed' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   uuid: { type: :string },
                   name: { type: :string },
                   pinyin: { type: :string }
                 },
                 required: %w[uuid name pinyin]
               }

        before { Card.create!(name: '打', pinyin: 'dǎ') }
        run_test!
      end
    end

    post 'Creates a card' do
      tags 'Cards'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :card, in: :body, schema: {
        type: :object,
        properties: {
          card: {
            type: :object,
            properties: {
              name: { type: :string },
              pinyin: { type: :string }
            },
            required: %w[name pinyin]
          }
        },
        required: %w[card]
      }

      response '201', 'card created' do
        schema type: :object,
               properties: {
                 uuid: { type: :string },
                 name: { type: :string },
                 pinyin: { type: :string }
               },
               required: %w[uuid name pinyin]

        let(:card) { { card: { name: '打', pinyin: 'dǎ' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string } }
               },
               required: %w[errors]

        let(:card) { { card: { name: '', pinyin: '' } } }
        run_test!
      end
    end
  end
end

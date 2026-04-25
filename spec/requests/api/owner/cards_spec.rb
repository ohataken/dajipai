require 'swagger_helper'

RSpec.describe 'api/owner/cards', type: :request do
  path '/api/owner/cards' do
    post 'Creates a card' do
      tags 'Owner Cards'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
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

      before do
        allow_any_instance_of(Api::Owner::CardsController)
          .to receive(:owner_token).and_return('valid-token')
      end

      response '201', 'card created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 uuid: { type: :string },
                 name: { type: :string },
                 pinyin: { type: :string },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               },
               required: %w[id uuid name pinyin created_at updated_at]

        let(:Authorization) { 'Bearer valid-token' }
        let(:card) { { card: { name: '打', pinyin: 'dǎ' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string } }
               },
               required: %w[errors]

        let(:Authorization) { 'Bearer valid-token' }
        let(:card) { { card: { name: '', pinyin: '' } } }
        run_test!
      end

      response '401', 'unauthorized' do
        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string } }
               },
               required: %w[errors]

        let(:Authorization) { 'Bearer wrong-token' }
        let(:card) { { card: { name: '打', pinyin: 'dǎ' } } }
        run_test!
      end
    end
  end
end

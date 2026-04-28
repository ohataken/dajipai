require 'swagger_helper'

RSpec.describe 'api/owner/cards', type: :request do
  path '/api/owner/cards' do
    post 'Creates a card' do
      tags 'Owner Cards'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :card, in: :body, schema: { '$ref' => '#/components/schemas/CardInput' }

      before do
        allow_any_instance_of(Api::Owner::CardsController)
          .to receive(:owner_token).and_return('valid-token')
      end

      response '201', 'card created' do
        schema '$ref' => '#/components/schemas/OwnerCard'

        let(:Authorization) { 'Bearer valid-token' }
        let(:card) { { card: { name: '打', pinyin: 'dǎ' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer valid-token' }
        let(:card) { { card: { name: '', pinyin: '' } } }
        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer wrong-token' }
        let(:card) { { card: { name: '打', pinyin: 'dǎ' } } }
        run_test!
      end
    end
  end
end

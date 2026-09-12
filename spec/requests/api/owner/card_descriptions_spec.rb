require 'swagger_helper'

RSpec.describe 'api/owner/cards/{card_uuid}/card_description', type: :request do
  path '/api/owner/cards/{card_uuid}/card_description' do
    parameter name: :card_uuid, in: :path, type: :string

    get 'Shows a card description' do
      tags 'Owner Card Descriptions'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true

      before do
        allow_any_instance_of(Api::Owner::CardDescriptionsController)
          .to receive(:owner_token).and_return('valid-token')
      end

      let(:existing_card) do
        card = Card.create!(name: '喝')
        CardDescription.create!(card: card, content: 'to drink')
        card
      end

      response '200', 'card description found' do
        schema '$ref' => '#/components/schemas/OwnerCardDescription'

        let(:Authorization) { 'Bearer valid-token' }
        let(:card_uuid) { existing_card.uuid }

        run_test! do |response|
          expect(JSON.parse(response.body)['content']).to eq('to drink')
        end
      end

      response '404', 'card description not found' do
        let(:Authorization) { 'Bearer valid-token' }
        let(:card_uuid) { Card.create!(name: '吃').uuid }
        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer wrong-token' }
        let(:card_uuid) { existing_card.uuid }
        run_test!
      end
    end
  end
end

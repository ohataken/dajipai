require 'swagger_helper'

RSpec.describe 'api/owner/cards/drafts', type: :request do
  path '/api/owner/cards/drafts' do
    get 'Lists draft cards' do
      tags 'Owner Cards'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true

      before do
        allow_any_instance_of(Api::Owner::Cards::DraftsController)
          .to receive(:owner_token).and_return('valid-token')
      end

      response '200', 'draft cards listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/OwnerCard' }

        let(:Authorization) { 'Bearer valid-token' }

        before do
          Card.create!(name: '打', pinyin: 'dǎ', published_at: 1.day.ago)
          Card.create!(name: '吃', pinyin: 'chī', published_at: 1.day.from_now)
          Card.create!(name: '喝')
        end

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body.map { |c| c['name'] }).to contain_exactly('喝')
        end
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer wrong-token' }
        run_test!
      end
    end
  end

  path '/api/owner/cards/drafts/{uuid}' do
    parameter name: :uuid, in: :path, type: :string

    get 'Shows a draft card' do
      tags 'Owner Cards'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true

      before do
        allow_any_instance_of(Api::Owner::Cards::DraftsController)
          .to receive(:owner_token).and_return('valid-token')
      end

      response '200', 'draft card found' do
        schema '$ref' => '#/components/schemas/OwnerCard'

        let(:Authorization) { 'Bearer valid-token' }
        let(:uuid) { Card.create!(name: '喝').uuid }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body['name']).to eq('喝')
          expect(body['published_at']).to be_nil
        end
      end

      response '404', 'draft card not found' do
        let(:Authorization) { 'Bearer valid-token' }
        let(:uuid) { Card.create!(name: '打', pinyin: 'dǎ', published_at: 1.day.ago).uuid }
        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer wrong-token' }
        let(:uuid) { Card.create!(name: '喝').uuid }
        run_test!
      end
    end
  end
end

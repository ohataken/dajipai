require 'swagger_helper'

RSpec.describe 'api/owner/cards', type: :request do
  path '/api/owner/cards' do
    post 'Creates a card' do
      tags 'Owner Cards'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :card, in: :body, schema: { '$ref' => '#/components/schemas/OwnerCardInput' }

      before do
        allow_any_instance_of(Api::Owner::CardsController)
          .to receive(:owner_token).and_return('valid-token')
      end

      response '201', 'card created' do
        schema '$ref' => '#/components/schemas/OwnerCard'

        let(:Authorization) { 'Bearer valid-token' }
        let(:card) { { card: { name: '打', pinyin: 'dǎ', published_at: '2026-09-01T00:00:00Z' } } }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(Time.zone.parse(body['published_at'])).to eq(Time.zone.parse('2026-09-01T00:00:00Z'))
          expect(Card.find_by!(uuid: body['uuid']).published_at).to eq(Time.zone.parse('2026-09-01T00:00:00Z'))
        end
      end

      response '201', 'draft card created' do
        schema '$ref' => '#/components/schemas/OwnerCard'

        let(:Authorization) { 'Bearer valid-token' }
        let(:card) { { card: { name: '打', pinyin: 'dǎ' } } }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body['published_at']).to be_nil
          expect(Card.find_by!(uuid: body['uuid']).published_at).to be_nil
        end
      end

      response '201', 'draft card created without pinyin' do
        schema '$ref' => '#/components/schemas/OwnerCard'

        let(:Authorization) { 'Bearer valid-token' }
        let(:card) { { card: { name: '打' } } }

        run_test! do |response|
          expect(JSON.parse(response.body)['pinyin']).to eq('')
        end
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer valid-token' }
        let(:card) { { card: { name: '', pinyin: '' } } }
        run_test!
      end

      response '422', 'draft card with null pinyin' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer valid-token' }
        let(:card) { { card: { name: '打', pinyin: nil } } }
        run_test!
      end

      response '422', 'published card without pinyin' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer valid-token' }
        let(:card) { { card: { name: '打', pinyin: '', published_at: '2026-09-01T00:00:00Z' } } }
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

  path '/api/owner/cards/{uuid}' do
    parameter name: :uuid, in: :path, type: :string

    put 'Updates a card' do
      tags 'Owner Cards'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :card, in: :body, schema: { '$ref' => '#/components/schemas/OwnerCardInput' }

      before do
        allow_any_instance_of(Api::Owner::CardsController)
          .to receive(:owner_token).and_return('valid-token')
      end

      let(:existing_card) { Card.create!(name: '打', pinyin: 'dǎ') }

      response '200', 'card updated' do
        schema '$ref' => '#/components/schemas/OwnerCard'

        let(:Authorization) { 'Bearer valid-token' }
        let(:uuid) { existing_card.uuid }
        let(:card) { { card: { name: '吃', pinyin: 'chī', published_at: '2026-09-01T00:00:00Z' } } }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(Time.zone.parse(body['published_at'])).to eq(Time.zone.parse('2026-09-01T00:00:00Z'))
          expect(existing_card.reload.published_at).to eq(Time.zone.parse('2026-09-01T00:00:00Z'))
        end
      end

      response '200', 'card unpublished' do
        schema '$ref' => '#/components/schemas/OwnerCard'

        let(:Authorization) { 'Bearer valid-token' }
        let(:existing_card) { Card.create!(name: '打', pinyin: 'dǎ', published_at: 1.day.ago) }
        let(:uuid) { existing_card.uuid }
        let(:card) { { card: { name: '打', pinyin: 'dǎ', published_at: nil } } }

        run_test! do |response|
          expect(JSON.parse(response.body)['published_at']).to be_nil
          expect(existing_card.reload.published_at).to be_nil
        end
      end

      response '404', 'card not found' do
        let(:Authorization) { 'Bearer valid-token' }
        let(:uuid) { 'non-existent-uuid' }
        let(:card) { { card: { name: '吃', pinyin: 'chī' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer valid-token' }
        let(:uuid) { existing_card.uuid }
        let(:card) { { card: { name: '', pinyin: '' } } }
        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer wrong-token' }
        let(:uuid) { existing_card.uuid }
        let(:card) { { card: { name: '吃', pinyin: 'chī' } } }
        run_test!
      end
    end
  end
end

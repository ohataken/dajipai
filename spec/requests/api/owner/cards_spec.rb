require 'swagger_helper'

RSpec.describe 'api/owner/cards', type: :request do
  path '/api/owner/cards' do
    get 'Lists cards including drafts' do
      tags 'Owner Cards'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :status, in: :query, schema: { '$ref' => '#/components/schemas/CardStatus' }, required: false

      before do
        allow_any_instance_of(Api::Owner::CardsController)
          .to receive(:owner_token).and_return('valid-token')

        published = Card.create!(name: '打', pinyin: 'dǎ', status: :published)
        published.tags << Tag.create!(name: '動詞', slug: 'verbs')
        CardDescription.create!(card: published, content: 'to hit')
        Card.create!(name: '吃', pinyin: 'chī', status: :draft)
      end

      response '200', 'cards listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/OwnerCard' }

        let(:Authorization) { 'Bearer valid-token' }
        let(:status) { nil }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body.map { |c| c['name'] }).to contain_exactly('打', '吃')
          expect(body.map { |c| c['status'] }).to contain_exactly('published', 'draft')
        end
      end

      response '200', 'cards filtered by status' do
        schema type: :array, items: { '$ref' => '#/components/schemas/OwnerCard' }

        let(:Authorization) { 'Bearer valid-token' }
        let(:status) { 'draft' }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body.map { |c| c['name'] }).to contain_exactly('吃')
        end
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer wrong-token' }
        let(:status) { nil }
        run_test!
      end
    end

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
        let(:card) { { card: { name: '打', pinyin: 'dǎ' } } }
        run_test! do |response|
          expect(JSON.parse(response.body)['status']).to eq('draft')
        end
      end

      response '201', 'card created as published' do
        schema '$ref' => '#/components/schemas/OwnerCard'

        let(:Authorization) { 'Bearer valid-token' }
        let(:card) { { card: { name: '打', pinyin: 'dǎ', status: 'published' } } }
        run_test! do |response|
          expect(JSON.parse(response.body)['status']).to eq('published')
        end
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

  path '/api/owner/cards/{uuid}' do
    parameter name: :uuid, in: :path, type: :string

    get 'Shows a card including drafts' do
      tags 'Owner Cards'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true

      before do
        allow_any_instance_of(Api::Owner::CardsController)
          .to receive(:owner_token).and_return('valid-token')
      end

      let(:draft_card) { Card.create!(name: '打', pinyin: 'dǎ', status: :draft) }

      response '200', 'card found' do
        schema '$ref' => '#/components/schemas/OwnerCard'

        let(:Authorization) { 'Bearer valid-token' }
        let(:uuid) { draft_card.uuid }
        run_test! do |response|
          expect(JSON.parse(response.body)['status']).to eq('draft')
        end
      end

      response '404', 'card not found' do
        let(:Authorization) { 'Bearer valid-token' }
        let(:uuid) { 'non-existent-uuid' }
        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer wrong-token' }
        let(:uuid) { draft_card.uuid }
        run_test!
      end
    end

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
        let(:card) { { card: { name: '吃', pinyin: 'chī' } } }
        run_test!
      end

      response '200', 'draft card published' do
        schema '$ref' => '#/components/schemas/OwnerCard'

        let(:Authorization) { 'Bearer valid-token' }
        let(:uuid) { existing_card.uuid }
        let(:card) { { card: { name: '打', pinyin: 'dǎ', status: 'published' } } }
        run_test! do |response|
          expect(JSON.parse(response.body)['status']).to eq('published')
          expect(existing_card.reload).to be_published
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

      response '422', 'invalid status' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer valid-token' }
        let(:uuid) { existing_card.uuid }
        let(:card) { { card: { name: '打', pinyin: 'dǎ', status: 'bogus' } } }
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

require 'swagger_helper'

RSpec.describe 'api/owner/cards/{card_uuid}/tags', type: :request do
  path '/api/owner/cards/{card_uuid}/tags' do
    parameter name: :card_uuid, in: :path, type: :string

    post 'Attaches a tag to a card' do
      tags 'Owner Card Tags'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :body, in: :body, schema: { '$ref' => '#/components/schemas/CardTagInput' }

      before do
        allow_any_instance_of(Api::Owner::CardTagsController)
          .to receive(:owner_token).and_return('valid-token')
      end

      let!(:card) { Card.create!(name: '打', pinyin: 'dǎ') }
      let!(:verbs) { Tag.create!(name: '動詞', slug: 'verbs') }

      response '201', 'tag attached' do
        schema '$ref' => '#/components/schemas/Card'

        let(:Authorization) { 'Bearer valid-token' }
        let(:card_uuid) { card.uuid }
        let(:body) { { tag_slug: 'verbs' } }

        run_test! do |response|
          parsed = JSON.parse(response.body)
          expect(parsed['tags']).to eq([ { 'slug' => 'verbs', 'name' => '動詞' } ])
        end
      end

      response '200', 'tag already attached (idempotent)' do
        schema '$ref' => '#/components/schemas/Card'

        before { card.tags << verbs }

        let(:Authorization) { 'Bearer valid-token' }
        let(:card_uuid) { card.uuid }
        let(:body) { { tag_slug: 'verbs' } }

        run_test! do |response|
          parsed = JSON.parse(response.body)
          expect(parsed['tags']).to eq([ { 'slug' => 'verbs', 'name' => '動詞' } ])
        end
      end

      response '422', 'tag not found' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer valid-token' }
        let(:card_uuid) { card.uuid }
        let(:body) { { tag_slug: 'nonexistent' } }

        run_test!
      end

      response '404', 'card not found' do
        let(:Authorization) { 'Bearer valid-token' }
        let(:card_uuid) { 'nonexistent-uuid' }
        let(:body) { { tag_slug: 'verbs' } }

        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer wrong-token' }
        let(:card_uuid) { card.uuid }
        let(:body) { { tag_slug: 'verbs' } }

        run_test!
      end
    end
  end
end

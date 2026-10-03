require 'swagger_helper'

RSpec.describe 'api/owner/tags/{tag_slug}/cards', type: :request do
  path '/api/owner/tags/{tag_slug}/cards' do
    parameter name: :tag_slug, in: :path, type: :string

    get 'Lists all cards belonging to a tag' do
      tags 'Owner Tags'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true

      before do
        allow_any_instance_of(Api::Owner::Tags::CardsController)
          .to receive(:owner_token).and_return('valid-token')
      end

      response '200', 'cards listed' do
        schema '$ref' => '#/components/schemas/OwnerTagWithCards'

        let(:Authorization) { 'Bearer valid-token' }
        let(:tag_slug) { 'verbs' }

        before do
          verbs = Tag.create!(name: '動詞', slug: 'verbs')
          greetings = Tag.create!(name: '挨拶', slug: 'greetings')
          Card.create!(name: '打', pinyin: 'dǎ', published_at: 1.day.ago).tags << [ verbs, greetings ]
          Card.create!(name: '吃', pinyin: 'chī', published_at: 1.day.from_now).tags << verbs
          Card.create!(name: '喝').tags << verbs
          Card.create!(name: '你好', pinyin: 'nǐ hǎo', published_at: 1.day.ago).tags << greetings
        end

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body['tag']).to include('slug' => 'verbs', 'name' => '動詞')
          cards = body['tag']['cards'].index_by { |c| c['name'] }
          expect(cards.keys).to contain_exactly('打', '吃', '喝')
          expect(cards['打']['tags']).to eq([ { 'slug' => 'greetings', 'name' => '挨拶' }, { 'slug' => 'verbs', 'name' => '動詞' } ])
          expect(cards['吃']['syllables']).to eq([ { 'letters' => 'chi', 'initial' => { 'letters' => 'ch', 'place_of_articulation' => 'retroflex', 'aspiration' => 'aspirated' }, 'final' => { 'letters' => 'i' } } ])
          expect(cards['喝']['syllables']).to eq([])
          expect(cards['喝']['published_at']).to be_nil
        end
      end

      response '404', 'tag not found' do
        let(:Authorization) { 'Bearer valid-token' }
        let(:tag_slug) { 'non-existent-slug' }
        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer wrong-token' }
        let(:tag_slug) { Tag.create!(name: '動詞', slug: 'verbs').slug }
        run_test!
      end
    end
  end
end

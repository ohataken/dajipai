require 'swagger_helper'

RSpec.describe 'api/tags/{tag_slug}/cards', type: :request do
  path '/api/tags/{tag_slug}/cards' do
    parameter name: :tag_slug, in: :path, type: :string

    get 'Lists cards belonging to a tag' do
      tags 'Tags'
      produces 'application/json'

      response '200', 'cards listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Card' }

        let(:tag_slug) { 'verbs' }

        before do
          verbs = Tag.create!(name: '動詞', slug: 'verbs')
          greetings = Tag.create!(name: '挨拶', slug: 'greetings')
          tagged = Card.create!(name: '打', pinyin: 'dǎ')
          tagged.tags << verbs
          CardDescription.create!(card: tagged, content: 'to hit')
          Card.create!(name: '你好', pinyin: 'nǐ hǎo').tags << greetings
        end

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body.map { |c| c['name'] }).to contain_exactly('打')
          expect(body.first['tags']).to eq([ { 'slug' => 'verbs', 'name' => '動詞' } ])
          expect(body.first['card_description']).to eq({ 'content' => 'to hit' })
        end
      end

      response '404', 'tag not found' do
        let(:tag_slug) { 'non-existent-slug' }
        run_test!
      end
    end
  end
end

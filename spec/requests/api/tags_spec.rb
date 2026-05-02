require 'swagger_helper'

RSpec.describe 'api/tags', type: :request do
  path '/api/tags' do
    get 'Lists tags' do
      tags 'Tags'
      produces 'application/json'

      response '200', 'tags listed' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Tag' }

        before do
          Tag.create!(name: '動詞', slug: 'verbs')
          Tag.create!(name: '挨拶', slug: 'greetings')
        end

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body.map { |t| t['slug'] }).to eq(%w[greetings verbs])
        end
      end
    end
  end
end

require 'swagger_helper'

RSpec.describe 'api/owner/tags', type: :request do
  path '/api/owner/tags' do
    post 'Creates a tag' do
      tags 'Owner Tags'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :tag, in: :body, schema: { '$ref' => '#/components/schemas/TagInput' }

      before do
        allow_any_instance_of(Api::Owner::TagsController)
          .to receive(:owner_token).and_return('valid-token')
      end

      response '201', 'tag created' do
        schema '$ref' => '#/components/schemas/OwnerTag'

        let(:Authorization) { 'Bearer valid-token' }
        let(:tag) { { tag: { name: '動詞', slug: 'verbs' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer valid-token' }
        let(:tag) { { tag: { name: '', slug: 'INVALID SLUG' } } }
        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/Errors'

        let(:Authorization) { 'Bearer wrong-token' }
        let(:tag) { { tag: { name: '動詞', slug: 'verbs' } } }
        run_test!
      end
    end
  end
end

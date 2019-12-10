require 'rails_helper'

RSpec.describe 'POST /api/v1/targets', type: :request do
  subject { post api_v1_targets_url, params: target_params, headers: headers, as: :json }

  let!(:topic) { create(:topic) }
  let!(:user) { create(:user) }

  context 'with logged-in user' do
    let(:headers) { auth_headers }

    context 'when the request is valid' do
      let(:target_params) do
        {
          target: attributes_for(:target, topic_id: topic.id)
        }
      end

      it 'returns the target' do
        subject
        expect(json).to include_json(
          target: {
            topic_id: topic.id,
            user_id: user.id,
            title: target_params[:target][:title],
            radius: target_params[:target][:radius],
            longitude: target_params[:target][:longitude].to_s,
            latitude: target_params[:target][:latitude].to_s
          }
        )
      end

      it 'returns a created status' do
        subject
        expect(response).to be_successful
      end

      it 'creates a target' do
        expect { subject }.to change { Target.count }.from(0).to(1)
      end
    end

    context 'reach the limit of targets' do
      let(:max) { Target::MAX_TARGET_LIMIT }
      let(:target_params) do
        {
          target: attributes_for(:target, topic_id: topic.id)
        }
      end

      context 'before to reach the limit' do
        let!(:targets) { create_list(:target, max - 1, user: user) }

        it 'returns the target' do
          subject
          expect(json).to include_json(
            target: {
              topic_id: topic.id,
              user_id: user.id,
              title: target_params[:target][:title],
              radius: target_params[:target][:radius],
              longitude: target_params[:target][:longitude].to_s,
              latitude: target_params[:target][:latitude].to_s
            }
          )
        end

        it 'returns a created status' do
          subject
          expect(response).to be_successful
        end

        it 'creates a target' do
          expect { subject }.to change { Target.count }.from(max - 1).to(max)
        end
      end

      context 'when the limit is reached' do
        let!(:targets) { create_list(:target, max, user: user) }

        it 'returns the error messages as a json' do
          subject
          error = I18n.t('api.models.target.errors.reached_limit', max: max)
          expect(json).to include_json(errors: { target: [error] })
        end

        it 'returns a bad request status' do
          subject
          expect(response).to have_http_status(:bad_request)
        end

        it 'does not create a target' do
          expect { subject }.not_to change { Target.count }
        end
      end
    end

    context 'when target params is missing' do
      let(:target_params) do
        {
          target: attributes_for(:target, topic_id: topic.id).except(:title)
        }
      end

      it 'returns the error messages as a json' do
        subject
        expect(json).to include_json(errors: { title: ['can\'t be blank'] })
      end

      it 'returns a bad request status' do
        subject
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create a target' do
        expect { subject }.not_to change { Target.count }
      end
    end

    context "when topic id doesn't exist" do
      let(:target_params) do
        {
          target: attributes_for(:target).merge(topic_id: 0)
        }
      end

      it 'returns the error messages as a json' do
        subject
        expect(json).to include_json(errors: { topic: ['must exist'] })
      end

      it 'returns a bad request status' do
        subject
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create a target' do
        expect { subject }.not_to change { Target.count }
      end
    end
  end

  context 'when the user is not authenticated' do
    let(:headers) { nil }
    let(:target_params) { nil }

    it 'returns the error messages as a json' do
      subject
      expect(json).to include_json(errors: [I18n.t('devise.failure.unauthenticated')])
    end

    it 'returns an unauthorized status' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end

    it 'does not create a target' do
      expect { subject }.not_to change { Target.count }
    end
  end
end

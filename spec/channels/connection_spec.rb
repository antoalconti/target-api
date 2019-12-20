require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  let!(:user) { create(:user) }

  it 'successfully connects' do
    auth = user.create_new_auth_token
    c = "/cable?access-token=#{auth['access-token']}&client=#{auth['client']}&uid=#{auth['uid']}"
    connect c
    expect(connection.current_user.id).to eq(user.id)
  end

  it 'rejects connection' do
    expect { connect '/cable' }.to have_rejected_connection
  end
end

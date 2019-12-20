require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  let(:user) { create(:user) }
  let!(:chat) { create(:chat, user_a: user) }

  before { stub_connection user_id: user.id }

  it 'subscribes to the room' do
    subscribe(room_id: chat.id)
    expect(subscription).to be_confirmed
  end

  it 'is rejected when no params id' do
    subscribe
    expect(subscription).to be_rejected
  end

  it 'subscribes to a stream when room id is provided' do
    subscribe(room_id: chat.id)
    expect(subscription).to be_confirmed
    expect(subscription.streams).to eq(["ChatRoom-#{chat.id}"])
  end
end

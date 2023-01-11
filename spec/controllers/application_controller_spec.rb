require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#authenticate_request' do
    context 'when the request has a valid Authorization header' do
      let(:user) { create(:user) }
      let(:token) { user.generate_auth_token }
      let(:request) { double(headers: { 'Authorization' => "Bearer #{token}" }) }

      before do
        allow(controller).to receive(:request).and_return(request)
        allow(User).to receive(:authenticate).and_return(user)
      end

      it 'sets the current_user' do
        expect(controller.current_user).to be_nil
        controller.send(:authenticate_request)
        expect(controller.current_user).to eq(user)
      end
    end

    context 'when the request has an invalid Authorization header' do
      let(:request) { double(headers: { 'Authorization' => 'Bearer invalid_token' }) }
    
      before do
        allow(controller).to receive(:request).and_return(request)
      end
    
      it 'responds with an unauthorized error' do
        expect(controller).to receive(:render).with(json: { error: 'Token is invalid' }, status: :unauthorized)
        controller.send(:authenticate_request)
      end
    end
    
    context 'when the request does not have an Authorization header' do
      let(:request) { double(headers: {}) }

      before do
        allow(controller).to receive(:request).and_return(request)
      end

      it 'responds with an unauthorized error' do
        expect(controller).to receive(:render).with(json: { error: 'Token is missing' }, status: :unauthorized)
        controller.send(:authenticate_request)
      end
    end
  end
end

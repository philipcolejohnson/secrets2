require 'rails_helper'

describe SecretsController do
  describe 'GET #show' do
    let (:secret) { create(:secret) }

    it "sets the right instance variable" do
      get :show, id: secret.id
      expect(assigns(:secret)).to match(secret)
    end
  end


end
require 'rails_helper'

describe SecretsController do
  let (:secret) { create(:secret) }

  describe 'GET #show' do
    it "sets the right instance variable" do
      get :show, id: secret.id
      expect(assigns(:secret)).to match(secret)
    end
  end

  context "Signed-in User" do
    let(:user) { create(:user) }
    before do
      session[:user_id] = user.id
      user.secrets << secret
    end

    describe "GET #edit" do
      it "renders an edit page" do
        get :edit, id: secret.id

        expect(response).to render_template :edit
      end
    end

    describe "POST #update" do
      it "updates a secret with valid attributes" do
        put :update, id: secret.id, secret: attributes_for(:secret, title: "New Secret")
        secret.reload

        expect(secret.title).to eql("New Secret")
      end
    end

    describe "DELETE #destroy" do
      it "deletes secret" do
        expect {
          delete :destroy, id: secret.id
        }.to change(Secret, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, id: secret.id

        expect(response).to redirect_to secrets_path
      end
    end
  end
end

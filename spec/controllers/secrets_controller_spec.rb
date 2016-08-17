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

      it "sets the right instance variables" do
        get :edit, id: secret.id
        expect(assigns(:secret)).to match(secret)
      end
    end

    describe "POST #update" do
      it "updates a secret with valid attributes" do
        put :update, id: secret.id, secret: attributes_for(:secret, title: "New Secret")
        secret.reload

        expect(secret.title).to eql("New Secret")
      end

      it "doesn't update a secret with invalid attributes" do
        put :update, id: secret.id, secret: attributes_for(:secret, title: nil)
        secret.reload
        expect(response).to render_template :edit
      end

      it "doesn't update a secret with invalid secret id" do
        expect{
          put :update, id: 123, secret: attributes_for(:secret, title: "New Secret")
          }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    describe "DELETE #destroy" do
      let(:secret2) { create(:secret) }

      it "deletes secret" do
        expect {
          delete :destroy, id: secret.id
        }.to change(Secret, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, id: secret.id

        expect(response).to redirect_to secrets_path
      end


      it "doesn't allow you to delete a secret that isn't yours" do

        expect {
          delete :destroy, id: secret2.id
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

    describe "POST #create" do

      it "will create a new secret with proper submission" do
        expect{
          post :create, secret: attributes_for(:secret)
         }.to change(Secret, :count).by(1)
      end

      it "will redirec to to show page with proper submission" do
        post :create, secret: attributes_for(:secret)
        expect(response).to redirect_to secret_path(assigns(:secret))
      end

      it "will not create a new secret with improper submission" do
        expect{
          post :create, secret: attributes_for(:secret, title: nil)
        }.to_not change(Secret, :count)
      end



      it "will render new page with improper submission" do
        post :create, secret: attributes_for(:secret, title: nil)
        expect(response).to render_template :new
      end

      it "sets notice flash message when successfully created" do
        post :create, secret: attributes_for(:secret)
        expect(flash[:notice]).to_not eq(nil)
      end

        it "no flash message when not successfully created" do
        post :create, secret: attributes_for(:secret, title: nil)
        expect(flash[:notice]).to eq(nil)
      end
    end
  end
end

require 'rails_helper'

describe UsersController do
  let(:user) { create(:user) }
  describe "POST #create" do

    it "will create a new user with proper submission" do
      expect{
        post :create, user: attributes_for(:user)
       }.to change(User, :count).by(1)
    end

    it "will redirecto to show page with proper submission" do
      post :create, user: attributes_for(:user)
      expect(response).to redirect_to user_path(assigns(:user))
    end

    it "will not create a new user with improper submission" do
      expect{
        post :create, user: attributes_for(:user, name: "no")
      }.to_not change(User, :count)
    end



    it "will render new page with improper submission" do
      post :create, user: attributes_for(:user, name: "no")
      expect(response).to render_template :new
    end
  end


  context "user is signed in" do
    before do
      session[:user_id] = user.id
    end

    describe "GET #edit" do
      it "renders an edit page" do
        get :edit, id: user.id

        expect(response).to render_template :edit
      end

      it "sets the right instance variables" do
        get :edit, id: user.id
        expect(assigns(:user)).to match(user)
      end
    end

    describe "PUT #update" do
      it "updates a user with valid attributes" do
        patch :update, id: user.id, user: attributes_for(:user, name: "New Name")
        user.reload

        expect(user.name).to eql("New Name")
      end

      it "doesn't update a user with invalid attributes" do
        put :update, id: user.id, user: attributes_for(:user, name: "no")
        user.reload
        expect(user.name).to eql("Foo")
      end

      it "doesn't update a user with invalid user id" do
        expect{
          put :update, id: 123, user: attributes_for(:user, name: "New User")
          }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    describe "DELETE #destroy" do
      let(:user2) { create(:user) }

      it "deletes user" do
        expect {
          delete :destroy, id: user.id
        }.to change(User, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, id: user.id
        expect(response).to redirect_to users_path
      end


      it "doesn't allow you to delete a user that isn't yours" do

        expect{
          delete :destroy, id: user2.id
        }.to_not change(User, :count)
      end


    end
  end
end

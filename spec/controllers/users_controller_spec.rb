require 'rails_helper'

describe UsersController do
  describe "POST #create" do
    #let(:user) { create(:user) }

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



    it "will render new page with improper submission"


  end
end
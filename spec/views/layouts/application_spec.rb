require "rails_helper"

describe "layouts/application.html.erb" do
  let(:user) { create(:user) }
  before do
    secret = create(:secret)
    secrets = [secret, create(:secret)]
    user.secrets = secrets
    assign(:secrets, secrets)
    @user = user
    def view.current_user
      @user
    end
  end

  context "Logged In user" do
    before do
      def view.signed_in_user?
        true
      end
    end

     it "can see a logout link" do
       render
       expect(rendered).to match("Logout")
     end

  end

  context "Not logged in user" do
    before do
      def view.signed_in_user?
        false
      end
    end

     it "shows a login link" do
       render
       expect(rendered).to match("Login")
     end
  end
end

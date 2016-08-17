require "rails_helper"

describe "secrets/index.html.erb" do
  let(:user) { create(:user) }
  let(:secret) { create(:secret) }
  before do
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
      secret
    end

     it "can see the authors of secrets" do
       render
       expect(rendered).to match(secret.author.name)
     end
  end

  context "Not logged in user" do
    before do
      def view.signed_in_user?
        false
      end
    end

     it "cannot see the authors of secrets" do
       render
       expect(rendered).to_not match(secret.author.name)
     end
  end
end

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "loads a new user" do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end

  describe "GET #create" do
    context "when credentials are valid" do
      let(:user) { create(:user) }

      before { get :create, username: user.username, password: 'password' }

      it "creates a new session for the user" do
        expect(session[:x]).to eql(user.id)
      end

      it "redirects the user to the dashboard" do
        expect(response).to redirect_to(agents_path)
      end
    end
  end

  describe "#destroy" do
    let(:user) { create(:user) }

    before :each do
      session[:x] = user.id
    end

    it "redirects to the login page" do
      delete :destroy, id: 'me'
      expect(response).to redirect_to(new_session_path)
    end

    it "resets the session" do
      delete :destroy, id: 'me'
      expect(session[:x]).to be_nil
    end
  end
end

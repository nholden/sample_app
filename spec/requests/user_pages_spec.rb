require 'spec_helper'

describe "User pages" do

  subject { page }


  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      before { create_user_with_email("user@example..com") }

      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      it "should return an error message" do
        click_button submit
        should have_content('Email is invalid') 
      end
    end

    describe "with valid information" do
      before { create_user_with_email("user@example.com") }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        it { should have_title('Example User') }
        it { should have_content('Welcome to the Sample App!') }
        it { should have_success_message('Welcome to the Sample App!') }

        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
      end
    end
  end
end


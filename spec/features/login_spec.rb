require "spec_helper"

describe "Login" do
  it "renders baby" do
    visit "/login"
    page.should have_content "Login"
  end

  describe "requesting a login link" do
    context "with invalid email" do
      it "display invalid email message" do
        login("test")
        expect(page).to have_content "That doesn't look like a valid email address."
      end
    end

    context "with valid email" do
      it "redirects to / with notice and sends email" do
        login("test@aol.com")
        expect(current_url).to eq root_url
        expect(page).to have_content "Your log in link has been emailed to you."
        expect(last_email.to).to include "test@aol.com"
      end
    end
  end

  describe "validating a login link" do
    context "when non-existent" do
      it "gives notice that the login link is invalid and redirects" do
        visit "/login/1/asdf"
        expect(page).to have_content "This is not a valid login link."
        expect(current_url).to eq root_url
      end
    end

    context "when already used" do
      it "gives notice that the login link is already used and redirects" do
        ls = FactoryGirl.create(:login_session)
        code = ls.code
        ls.update_attributes(activated_at: Time.now)
        visit "/login/#{ls.id}/#{code}"
        expect(page).to have_content "This login link has already been used."
        expect(current_url).to eq root_url
      end
    end

    context "when older than 60 min" do
      it "gives notice that the login link is expired and redirects" do
        ls = FactoryGirl.create(:login_session, created_at: 65.minutes.ago)
        visit "/login/#{ls.id}/#{ls.code}"
        expect(page).to have_content "This login link has expired."
        expect(current_url).to eq root_url
      end
    end

    context "when valid" do
      context "when user doens't already exist" do
        it "sets session, creates user, and redirects" do
          ls = FactoryGirl.create(:login_session)

          expect {
            visit "/login/#{ls.id}/#{ls.code}"
          }.to change{ User.count }.by(1)

          expect(page).to have_content "Welcome back!"
          expect(current_url).to eq home_url
        end
      end

      context "when user already exists" do
        it "sets session, finds user, and redirects" do
          ls = FactoryGirl.create(:login_session)
          user = FactoryGirl.create(:user)

          expect {
            visit "/login/#{ls.id}/#{ls.code}"
          }.to change{ User.count }.by(0)

          expect(page).to have_content "Welcome back!"
          expect(current_url).to eq home_url
        end
      end
    end
  end

  describe "requiring authentication" do
    context "when accessing a secure page" do
      it "redirects to login page with notice" do
        visit "/home"
        expect(page).to have_content "Please login."
        expect(current_url).to eq login_sessions_url
      end
    end
  end

  describe "logging out" do
    context "when logging out" do
      it "doesn't allow access to a secure page" do
        ls = FactoryGirl.create(:login_session)
        user = FactoryGirl.create(:user)

        expect {
          visit "/login/#{ls.id}/#{ls.code}"
        }.to change{ User.count }.by(0)
        visit "/logout"

        visit "/home"
        expect(page).to have_content "Please login."
        expect(current_url).to eq login_sessions_url
      end
    end
  end

end


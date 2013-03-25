require 'spec_helper'

describe LoginSession do
  let(:login_session) { FactoryGirl.create(:login_session) }

  context "before create" do
    it "sets code" do
      expect(login_session.reload.code).to be
    end

    it "sets salted_code" do
      expect(login_session.reload.hashed_code).to be
    end
  end

  describe ".create_from_email" do
    it "creates a login session" do
      expect{
        LoginSession.create_from_email("test@aol.com")
      }.to change{ LoginSession.count }.by(1)
    end

    it "returns the LoginSession" do
      ls = LoginSession.create_from_email("test@aol.com")
      expect(ls).to be_a LoginSession
    end
  end

  describe "#activated?" do
    context "when activated_at" do
      it "returns true" do
        ls = FactoryGirl.build(:login_session, activated_at: Time.now)
        expect(ls.activated?).to be_true
      end
    end

    context "when not activated_at" do
      it "returns false" do
        ls = FactoryGirl.build(:login_session)
        expect(ls.activated?).to be_false
      end
    end
  end

  describe "#terminated?" do
    context "when terminated_at" do
      it "returns true" do
        ls = FactoryGirl.build(:login_session, terminated_at: Time.now)
        expect(ls.terminated?).to be_true
      end
    end

    context "when not terminated_at" do
      it "returns false" do
        ls = FactoryGirl.build(:login_session)
        expect(ls.terminated?).to be_false
      end
    end
  end

  describe "#expired?" do
    context "within the last hour" do
      it "returns false" do
        DateTime.stub(:current).and_return(10.minutes.ago)
        ls = FactoryGirl.create(:login_session, created_at: 30.minutes.ago)
        expect(ls.expired?).to be_false
      end
    end

    context "outside the last hour" do
      it "returns true" do
        DateTime.stub(:current).and_return(10.minutes.ago)
        ls = FactoryGirl.create(:login_session, created_at: 90.minutes.ago)
        expect(ls.expired?).to be_true
      end
    end
  end

  describe "#activate_session!" do
    context "when code is correct" do
      let(:ls) { FactoryGirl.create(:login_session) }

      before :each do
        ls.activate_session!(ls.code, "10.0.0.1", "Awesome agent")
      end

      it "sets activated time" do
        expect(ls.activated_at).to be
      end

      it "sets ip" do
        expect(ls.ip).to eq "10.0.0.1"
      end

      it "sets user agent" do
        expect(ls.user_agent).to eq "Awesome agent"
      end
    end
  end
end

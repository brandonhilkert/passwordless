require "spec_helper"

describe LoginMailer do
  describe "code" do
    let(:code) { "secret" }
    let(:email) { "test@aol.com" }
    let(:id) { 1 }
    let(:mail) { LoginMailer.code(email, id, code) }

    it "sends to the correct recipient" do
      mail.to.should eq([email])
    end

    it "includes the login link" do
      expect(mail.body.encoded).to include code
    end
  end

end

require "spec_helper"

describe "Landing Page" do
  it "renders baby" do
    visit "/"
    page.should have_content "Baby"
  end

  it "has a link to Login" do
    visit "/"
    page.should have_content "Login"
  end
end

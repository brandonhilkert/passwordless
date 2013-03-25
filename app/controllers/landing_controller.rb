class LandingController < ApplicationController
  def index
    redirect_to home_url if current_user
  end
end

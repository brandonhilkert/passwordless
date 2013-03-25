class HomeController < ApplicationController
  before_filter :requires_authentication!

  def index
  end
end

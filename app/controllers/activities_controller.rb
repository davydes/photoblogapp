class ActivitiesController < ApplicationController
  before_action :signed_in_user

  def index
    @activities = current_user.recent_activities(20)
  end
end

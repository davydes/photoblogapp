module UserResourceable
  extend ActiveSupport::Concern

  included do
    before_action :signed_in_user
    before_action :set_resource , only: [:edit, :update, :destroy]
    before_action :correct_user, only: [:edit, :update, :destroy]
  end

  private

  def set_resource
    association = controller_name.classify.downcase
    resource = current_user.send(association.to_s.pluralize).find(params[:id])
    instance_variable_set("@#{association}", resource)
  end

  def correct_user
    association = controller_name.classify.downcase
    redirect_to root_path unless admin_or_current?(instance_variable_get("@#{association}").user)
  end
end
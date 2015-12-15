class Impression < ActiveRecord::Base
  belongs_to :impressionable, :polymorphic=>true

  before_save :check_for_referer

  private

  def check_for_referer
    if referer.present?
      return true
    else
      return false
    end
  end
end

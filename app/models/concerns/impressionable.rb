module Impressionable
  extend ActiveSupport::Concern

  included do
    has_many :impressions, :as=>:impressionable
  end

  def impression_count
    impressions.length
  end

  def unique_impression_count
    impressions.group_by{ |impression| impression.ip_address }.length
  end
end
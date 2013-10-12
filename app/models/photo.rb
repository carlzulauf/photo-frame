class Photo < ActiveRecord::Base
  def self.random
    order("random()")
  end
end

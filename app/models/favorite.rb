class Favorite < ApplicationRecord
  belongs_to :item
  belongs_to :user
  
  validate do
    unless user && user.favoritable_for?(item)
      errors.add(:base, :invalid)
    end
  end
end

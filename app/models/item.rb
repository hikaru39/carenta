class Item < ApplicationRecord
  extend Enumerize
  
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  
  enumerize :status, in: { hidden: 0, editing: 1, applying: 2, applied: 3 }, default: :editing, scope: true
  
  class << self
    def search(query)
      rel = order("id")
      if query.present?
        rel = rel.where("name LIKE ?", "%#{query}%")
      end
      rel
    end
  end
end

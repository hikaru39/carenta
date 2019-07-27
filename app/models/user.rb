class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: true
  validates :name, presence: true, length: { maximum: 15 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :email, email: { allow_blank: true }
  
  class << self
    def search(query)
      rel = order("id")
      if query.present?
        rel = rel.where("name LIKE ?", "%#{query}%", "%#{query}%")
      end
      rel
    end
  end
end

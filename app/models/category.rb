class Category < ApplicationRecord
  has_many :items
  has_ancestry
  
  def self.get_children(id)
    self.find_by(id: id, ancestry: nil).children
  end
  
  def self.get_grandchildren(id)
    self.find_by(id: id).children
  end
end

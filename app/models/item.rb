class Item < ApplicationRecord
  extend Enumerize
  
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :category
  has_many :images, class_name: "ItemImage"
  has_many :favorites, dependent: :destroy
  has_many :favoriters, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  has_many :commenters, through: :comments, source: :user
  has_many :orders, dependent: :destroy
  
  enumerize :status, in: { hidden: 0, editing: 1, applying: 2, applied: 3 }, default: :editing, scope: true
  
  class << self
    def search(params)
      rel = order("id")
      if params[:q].present?
        rel = rel.where("name LIKE ? OR category LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
      end
      if params[:user_id].present?
        rel = rel.where(user_id: params[:user_id])
      end
      rel
    end
  end
end

class Item < ApplicationRecord
  extend Enumerize
  
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :category
  has_many :images, class_name: "ItemImage"
  has_many :favorites, dependent: :destroy
  has_many :favoriters, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  has_many :commenters, through: :comments, source: :user
  has_one :order, dependent: :destroy
  
  enumerize :status, in: { hidden: 0, editing: 1, applying: 2, applied: 3 }, default: :applying, scope: true
  
  class << self
    def search(params)
      rel = self.all

      if params[:q].present?
        rel = rel.where("name LIKE ? OR description LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
      end
      if params[:parent_id].present?
        child_category = Category.find_by(id: params[:parent_id])
        rel = rel.where(category_id: child_category.indirect_ids)
      end
      if params[:child_id].present?
        child_category = Category.find_by(id: params[:child_id])
        rel = rel.where(category_id: child_category.child_ids)
      end
      if params[:category_id].present?
        rel = rel.where(category_id: params[:category_id])
      end
      if params[:user_id].present?
        rel = rel.where(user_id: params[:user_id])
      end
      
      if params[:option] == "B"
        rel = rel.order(:created_at)
      elsif params[:option] == "C"
        rel = rel.order(point: :desc)
      elsif params[:option] == "D"
        rel = rel.order(:point)
      else # params[:option] == "A" or other
        rel = rel.order(created_at: :desc)
      end
      rel
    end
  end
end

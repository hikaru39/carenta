class User < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  
  has_secure_password
  
  has_many :items, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_items, through: :favorites, source: :item
  has_many :comments, dependent: :destroy
  has_many :commenters, through: :comments, source: :item
  has_many :points, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one_attached :profile_picture
  attribute :new_profile_picture
  attribute :remove_profile_picture, :boolean
  
  validates :email, {presence: true, uniqueness: { case_sensitive: false }}
  validates :name, presence: true, length: { maximum: 15 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :first_name, presence: true, length: { maximum: 20 }
  
  attr_accessor :current_password
  validates :password, presence: { if: :current_password }
  
  validate if: :new_profile_picture do
    if new_profile_picture.respond_to?(:content_type)
      unless new_profile_picture.content_type.in?(ALLOWED_CONTENT_TYPES)
        errors.add(:new_profile_picture, :invalid_image_type)
      end
    else
      errors.add(:new_profile_picture, :invalid)
    end
  end
  
  before_save do
    if new_profile_picture
      self.profile_picture = new_profile_picture
    elsif remove_profile_picture
      self.profile_picture.purge
    end
  end
  
  after_create do
    points.create!({ difference: 0, point: 0, processed_at: Time.current, category: "新規作成"})
  end
  
  def full_name
    last_name + first_name
  end
  
  def latest_point
    points.latest.first.point
  end
  
  def favoritable_for?(item)
    item && item.user != self && !favorites.exists?(item_id: item.id)
  end
  
  class << self
    def search(query)
      rel = order("id")
      if query.present?
        rel = rel.where("name LIKE ? OR last_name LIKE ? OR first_name LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
      end
      rel
    end
  end
end

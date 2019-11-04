class Point < ApplicationRecord
  belongs_to :user
  validates :processed_at, uniqueness: { scope: :user_id, message: "処理日時が重複しています。" }
  
  scope :latest, -> { order(processed_at: :desc) }
  
  def latest_point
    latest.first
  end
end

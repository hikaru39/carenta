class Order < ApplicationRecord
  extend Enumerize
  
  belongs_to :item
  belongs_to :user

  enumerize :status, in: { ordered: 0, delivered: 1, received: 2, returned: 3, finished: 4 }, default: :ordered, scope: true
  
  def type
    if status.finished? && returned_at.nil? 
      :buy
    else
      :rental
    end
  end
end

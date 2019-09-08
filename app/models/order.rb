class Order < ApplicationRecord
  extend Enumerize
  
  belongs_to :item
  belongs_to :user
  
  enumerize :type, in: { rental: 0, buy: 1, rental_buy: 2 }, default: :rental_buy, scope: true
  enumerize :status, in: { in_rental: 0, returned: 1, purchased: 2 }, default: :in_rental, scope: true
end

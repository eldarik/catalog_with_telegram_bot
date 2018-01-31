class Order < ApplicationRecord
  belongs_to :client
  has_many :order_elements, dependent: :destroy
  has_many :products, through: :order_elements
end

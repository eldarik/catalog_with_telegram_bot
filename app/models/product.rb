class Product < ApplicationRecord
  belongs_to :category

  scope :search, -> (q) {
    where('name ilike ? or description ilike ?', "%#{q}%", "%#{q}%")
  }
end

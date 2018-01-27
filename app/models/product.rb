class Product < ApplicationRecord
  belongs_to :category
  has_attachments :images, maximum: 5

  scope :search, -> (q) {
    where('name ilike ? or description ilike ?', "%#{q}%", "%#{q}%")
  }
end

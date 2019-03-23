class Product < ApplicationRecord
  include PgSearch

  belongs_to :category
  has_one :department, through: :category
  has_attachments :images, maximum: 5

  multisearchable against: %i[name description],
                  associated_against: {
                    category: %i[name],
                    department: %i[name]
                  }

  pg_search_scope :search, against: %i[name description], associated_against: {
    category: %i[name],
    department: %i[name]
  }

end

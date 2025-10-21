class Recipe < ApplicationRecord
  belongs_to :user
  validates :title, :instructions, :prep_time, :cook_time, presence: true
  validates :prep_time, :cook_time, comparison: { greater_than: 0 }

end
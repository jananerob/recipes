class Recipe < ApplicationRecord
  belongs_to :user
  validates :title, :instructions, :prep_time, :cook_time, presence: true
  validates :prep_time, :cook_time, comparison: { greater_than: 0 }

  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags

  accepts_nested_attributes_for :recipe_tags, allow_destroy: true

end
class Like < ApplicationRecord
  belongs_to :chef
  belongs_to :recipe

  validates :chef_id, presence: true
  validates :recipe_id, presence: true
  validates_uniqueness_of :chef, scope: :recipe
end

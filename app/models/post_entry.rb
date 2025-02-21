class PostEntry < ApplicationRecord
  belongs_to :user
  belongs_to :latest_post, class_name: "Post", optional: true
  has_many :posts, foreign_key: "entry_id", dependent: :destroy

  validates :timestamp_id, presence: true, uniqueness: true

  def to_param
    timestamp_id
  end
end

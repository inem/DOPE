class Post < ApplicationRecord
  self.table_name = "posts"
  self.primary_key = "id"

  belongs_to :user
  belongs_to :entry, class_name: "PostEntry", foreign_key: "entry_id"
  belongs_to :parent, class_name: "Post", optional: true
  has_many :versions, class_name: "Post", foreign_key: "parent_id"

  # Атрибуты
  attribute :uuid, :string
  attribute :parent_id, :integer
  attribute :version, :integer
  attribute :similarity, :float
  attribute :latest, :boolean
  attribute :content_hash, :string
  attribute :prefix_hash, :string
  attribute :timestamp_id, :string

  validates :content, presence: true
  validates :uuid, presence: true
  validates :timestamp_id, presence: true

  scope :originals, -> { where(parent_id: nil) }
  scope :versions, -> { where.not(parent_id: nil) }

  attr_accessor :user_uuid

  delegate :timestamp_id, to: :entry

  def title
    first_line = content.to_s.lines.first.to_s.strip
    html = Dope.markdown.render(first_line)
    plain_text = html
      .gsub(/<[^>]+>/, "")
      .gsub(/\s+/, " ")
      .strip

    max_length = Dope.config.posts.title_max_length
    plain_text.length > max_length ? "#{plain_text[0...max_length-3]}..." : plain_text
  end
end

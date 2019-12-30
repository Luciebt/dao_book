class Article < ActiveRecord::Base
  has_and_belongs_to_many :categories
  validates :title, presence: true
  validates :content, presence: true

  def markdown_content
    Kramdown::Document.new(content).to_html.html_safe
  end
end

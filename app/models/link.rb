class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  URL_FORMAT = /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?\Z/i
  GIST_LINK  = /https*:\/\/gist.github.com\/\w+/

  validates :name, presence: true
  validates :url, presence: true,
            length: { in: 2..200 },
            format: URI::DEFAULT_PARSER.make_regexp(['http', 'https', '<script src="https://gist.github'])
            # format: { with: URL_FORMAT }

  def gist?
    url ? url.match(GIST_LINK).present? : nil
  end
end

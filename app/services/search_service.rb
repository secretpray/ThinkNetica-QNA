class SearchService
  TYPES = %w[Question Answer Comment User].freeze

  def self.call(query:, type: nil)
    klass = TYPES.include?(type) ? type.constantize : ThinkingSphinx
    escaped_query = ThinkingSphinx::Query.escape(query)
    klass.search escaped_query
  end
end

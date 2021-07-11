class SearchService
  TYPES = %i[all question answer comment user].freeze

  def self.call(request:, type:)
    klass = type == 'all' ? ThinkingSphinx : type.capitalize.constantize
    klass.search ThinkingSphinx::Query.escape(request)
  end
end

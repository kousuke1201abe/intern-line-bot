require 'wikipedia'

class WikipediaAPIClient
  attr_reader :query

  def initialize(query:)
    @query = query
  end

  def search_text
    Wikipedia.Configure {
      domain 'ja.wikipedia.org'
      path   'w/api.php'
    }

    page = Wikipedia.find(query)

    page.text ? page.text.gsub(/[\r\n]/,"") : "該当の　記事がなかった　みたいです"
  end
end

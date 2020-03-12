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

    page.text ? page.text.gsub(/[\r\n]/,"").gsub(/[1]|[2]|[3]|[4]|[5]|[6]|[7]|[8]|[9]|[0]/, '０'): "該当の　記事がなかった　みたいです"
  end
end

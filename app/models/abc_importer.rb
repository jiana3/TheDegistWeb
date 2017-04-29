require 'Date'
require 'rss'
require 'open-uri'

class AbcImporter < News::Importer
  URL = 'http://www.abc.net.au/local/rss/all.xml'
  
  def initialize start_date, end_date
    super
  end
  
  def self.source_name
    'AbcImporter'
  end
  
  def scrape
    open(URL) do |rss|
      feed = RSS:: Parser.parse(rss)
      feed.items.each do |item|
        if item.description.nil?
          summary = nil
        else summary = item.description.gsub(/\n+|\r+/, "\n").squeeze("\n").strip
        end
        author = 'ABC'
        source = feed.channel.title
        title = item.title
        image = nil
        link = item.link
        date = item.pubDate.to_s
        add_article(author, title, summary, image, source, date, link)
      end
    end
  end
end
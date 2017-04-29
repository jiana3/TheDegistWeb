require 'Date'
require 'rss'
require 'open-uri'

class HsImporter < News::Importer
  URL = 'http://feeds.news.com.au/heraldsun/rss/heraldsun_news_breakingnews_2800.xml'
  
  def initialize start_date, end_date
    super
  end
  
  def self.source_name
    'HsImporter'
  end
  
  def scrape
    open(URL) do |rss|
      feed = RSS:: Parser.parse(rss)
      feed.items.each do |item|
        author = item.source.to_s.split('>',2).last.split('<').first.gsub('By ','')
        link = item.guid.to_s.split('>',2).last.split('<').first
        if !item.enclosure.nil?
          image = nil
        else image = item.enclosure.to_s.split('"')[1]
        end
        title = item.title
        date = item.pubDate.to_s
        summary = item.description
        source = feed.channel.title
        add_article(author, title, summary, image, source, date, link)
      end
    end
  end
end
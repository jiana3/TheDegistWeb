require 'Date'
require 'rss'
require 'open-uri'

class SmhImporter < News::Importer
  URL = 'http://www.smh.com.au/rssheadlines/nsw/article/rss.xml'
  
  def initialize start_date, end_date
    super
  end
  
  def self.source_name
    'SmhImporter'
  end
  
  def scrape
    open(URL) do |rss|
      feed = RSS:: Parser.parse(rss)
      feed.items.each do |item|
        summary = item.description.split('</p>').last
        if summary == '&#160;'
          summary = nil
        else summary.last.gsub('&#160;',' ')
        end
        if item.description.split('"')[1].nil?
          image = nil
        else image = item.description.split('"')[1]
        end
        title = item.title
        author = 'The Sydney Morning Herald'
        source = feed.channel.title
        date = item.pubDate.to_s
        link = item.link
        add_article(author, title, summary, image, source, date, link)
	  end
	end
  end
end
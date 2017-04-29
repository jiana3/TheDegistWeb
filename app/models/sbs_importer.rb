#  SBSImporter Importer Class
require 'Date'
require 'rss'
require 'open-uri'
class SbsImporter < News::Importer
  URL = 'http://www.sbs.com.au/news/rss/news/science-technology.xml'
#  We call super in the initialize method
  def initialize start_date, end_date
    super
  end

#  Define the class method for file_name, this should
#  return something similar to the name for your importer
  def self.source_name
    'SBSImporter'
  end
#  Scrape method that read the feed
  def scrape
    begin
      open(URL) do |rss|
        feed = RSS::Parser.parse(rss)
        feed.items.each do |item|
          author = 'SBS'
          title = item.title
          summary = item.description
          images = nil
          source = 'SBS'
          link = item.link
          date = item.pubDate
          add_article(author, title, summary, images, source, date, link)
        end
      end
    rescue Exception => msg
      puts msg
    end     
  end
end
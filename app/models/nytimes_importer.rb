#  New York Times Importer Class
require 'Date'
require 'json'
require 'net/http'
class NytimesImporter < News::Importer
    #  Define the URL
    URL = "http://api.nytimes.com"
    URLSITE="http://www.nytimes.com/"
    #  Define the api_key
    API_KEY = "ca116a32a3678690421816415de42058:0:72676086"
    #  Initialize method
    def initialize start_date, end_date
    super(start_date,end_date)
    #  Define the request_url
    @request_url = getUrlRequest(API_KEY,@start.strftime("%Y%m%d"),@end.strftime("%Y%m%d"))
    end
    def getUrlRequest(api_key,begin_date, end_date)
       return url_request="/svc/search/v2/articlesearch.json?begin_date=#{begin_date}&end_date=#{end_date}&api-key=#{api_key}"
    end
    
    #  Name of the importer
    def self.source_name
        "NYImporter"
    end

    #  Scrape method that saves canned article data
    def scrape
        scraped_articles=[]
        scraped_articles=scrape_articles(false)
        #  Iterate through the API List
        scraped_articles['response']['docs'].each do |item|
            process_item (item)
        end
    end
    def process_item (item)
    begin
        image_url = nil
        author = 'not specified'
        date =item['pub_date']
        title= item['headline']['print_headline']
        if item['byline'].first !=nil
          author = item['byline']['original'].split('By ').last
        end
        summary= item['snippet']
        if item['multimedia'].first != nil
           image = item['multimedia'].first
           if image!= nil
             image_url = URLSITE+image['url']
           end
        end
        source= item['web_url']
        section_name =item['section_name']
        document_type= item['document_type']
        news_desk = item['news_desk']
        main_source=item['source']
        # Add Article to array
        add_article(author, title, summary, image_url, main_source, date,source)
    rescue Exception => msg
        puts msg
    end
    end
    # Connect to the feed, and return an array of articles
    def scrape_articles(use_ssl)
        #  Define the HTTP object
        uri = URI.parse(URL)
        http = Net::HTTP.new(uri.host, uri.port)
        #  If the api being scraped uses https, then set use_ssl to true.
        http.use_ssl = use_ssl
        #  Make a GET request to the given url
        response = http.send_request('GET', @request_url)
        #  Parse the response body
        return scraped_articles = JSON.parse(response.body)
    end

    
end
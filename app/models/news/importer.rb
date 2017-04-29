# 
module News
  class Importer

    #  A news scrape is initialised with the start and end date, it
    #  then validates that the required methods are provided
    def initialize start_date, end_date
      @start = start_date
      @end = end_date
      @articles = []     
    end

    #  Method to return news articles, ensuring that we only return
    #  unique news articles
    def articles
      @articles.uniq
    end

    private

    #  Create a new article and add it to the array
    def add_article(author, title, summary, images, source, date,url)
         article = Article.new( img_url: images, source: source,
                                title: title, summary: summary,
                                url: url, publish_date: date,author: author)
        @articles.push(article)
    end
    def get_tags description
        tags = description.scan(/\p{Upper}\w+/)
        return tags.join(",")
    end
    
    def self.get_sources
        importers ={
        "NYImporter" => NytimesImporter,
		"AbcImporter" => AbcImporter,
        "AgeImporter" => AgeImporter,
        "HsImporter" => HsImporter,
        "SmhImporter" => SmhImporter,
        "SBSimporter" => SbsImporter,
        "GuardianImporter" => GuardianImporter
        } 
        return importers
    end    
    def self.scrape_source importer_klass
      #  Set our start and end date
      start_date = ::Date.today - 7
      end_date = ::Date.today
     # Scrape the selected importer     
        instance = importer_klass.new(start_date, end_date)
        instance.scrape
        return instance.articles
    end
    
  end
end

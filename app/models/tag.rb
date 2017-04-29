require 'indico'
#Tagging class
class Tag
  INDICO_API_KEY =  'cdaa2a0007ce0ee846392878779b1c6b'  
  def initialize
      Indico.api_key = INDICO_API_KEY
      Sentimental.load_defaults
      Sentimental.threshold = 0.1        
  end
  
  def get_tags text
      text = text
      tags = []
      if !text.empty?         
      tags.concat get_sentimental_tags text
      tags.concat get_keywords_tags text
      tags.concat get_text_tags text
      tags.concat get_proper_nouns_tags text
      tags.concat get_nouns_tags text
      end
      return tags.map(&:upcase)
  end
  
  private 
  # Get sentimental tags
  def get_sentimental_tags text  
    sentiment = []  
    sent_tag = Sentimental.new    
    sentiment.push(sent_tag.get_sentiment text)
    return sentiment
  end
  def get_keywords_tags text
      # use the first 5 keywords obtained using Indico  
      keywords_from_text = Indico.keywords(text, {top_n: 5})   
      return keywords_from_text.keys
  end
  
  def get_text_tags text
      # the text_tags 5 from Indico returns the topics in the text       
      topics_from_text = Indico.text_tags(text, {top_n: 5})
      return topics_from_text.keys
  end    
  # Get proper nouns
  def get_proper_nouns_tags text
      # EngTagger adds Part-Of-Speech tags to each token in the text.
      # For example: if the text is 'The cute cat' the result will be:
      #'The/ARTICLE cute/ADJECTIVE cat/NOUN'
      # we considerer as tags just the nouns and proper nouns.
      tgr = EngTagger.new
      tagged = tgr.add_tags(text)      
      proper = tgr.get_proper_nouns(tagged)        
      return proper.keys
  end
  # Get nouns
  def get_nouns_tags text
      tgr = EngTagger.new
      tagged = tgr.add_tags(text)
      nouns = tgr.get_nouns(tagged)       
      return nouns.keys
  end
end
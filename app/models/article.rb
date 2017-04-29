class Article < ActiveRecord::Base
    acts_as_taggable
    validates_uniqueness_of :title, scope: :publish_date
    scope :by_articleid, -> (article_id){ where('id > ?', article_id) }
    scope :recent, -> { order("articles.id DESC") }

  def self.search_tag(search)
    where('tags.name LIKE ?', "%#{search}%")
  end
  def self.search_title(search)
    where('title LIKE ?', "%#{search}%")
  end
  def self.search_description(search)
    where('summary LIKE ?', "%#{search}%")
  end
  def self.search_source(search)
    where('source LIKE ?', "%#{search}%")
  end
  def self.search_possible(search)
    where('title LIKE ? OR summary LIKE ? OR tags.name LIKE ? OR source LIKE?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
  end
  
  def self.weighting(key)
    all_possible = Article.joins(:tags).group('Articles.id').search_possible(key)
    hash = Hash.new
    all_possible.each{|e| hash[e.id]=0}
    all_tag = Article.joins(:tags).group('Articles.id').search_tag(key)#.order('id ASC')
    all_title = Article.joins(:tags).group('Articles.id').search_title(key)#.order('id ASC')
    all_des = Article.joins(:tags).group('Articles.id').search_description(key)#.order('id ASC')
    all_source = Article.joins(:tags).group('Articles.id').search_source(key)#.order('id ASC')
    all_tag.each{|e| hash[e.id]=hash[e.id]+4}
    all_title.each{|e| hash[e.id]=hash[e.id]+3}
    all_des.each{|e| hash[e.id]=hash[e.id]+2}
    all_source.each{|e| hash[e.id]=hash[e.id]+1}
    return hash.sort_by{|k,v|[v,k]}.to_h
  end
  
  def self.hash_compare(pre_hash,cur_hash)
    matches = pre_hash.keys&cur_hash.keys
    hash = Hash.new
    matches.each{|e| hash[e] = pre_hash[e]+cur_hash[e]}
    return hash.sort_by{|k,v|[v,k]}.to_h
  end
end
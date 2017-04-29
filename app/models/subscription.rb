# Subscription Model
class Subscription < ActiveRecord::Base
belongs_to :user
belongs_to :article
  # Getting information to send mails to subscribers
  def self.emailing_subscription()
    templates =[]
    users = get_subscribers
    users.each do |user|
    articles = get_interest_article(user)
    id = 0
      unless articles.empty?
        first = articles.first
        id= first.id
        logger.debug "User dont have articles"
      end 
    template = ContentTemplate.new(user.email, user.first_name, articles, id, user.id)
    templates.push(template)
    end
    return templates
  end
  # Getting articles of interest
  def self.get_interest_article (user)  
    return Article.tagged_with(user.tag_list, :any => true).by_articleid(user.last_article_id).recent
  end        
  # Get Subscribers
  def self.get_subscribers
    return User.where("is_subscriber = ?", true)
  end  
end
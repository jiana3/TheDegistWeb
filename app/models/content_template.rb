
# Content Template
class ContentTemplate
attr_reader :email, :name, :articles, :last_article_id, :user_id


def initialize email, name, articles, last_article_id, user_id
      @email = email
      @name = name
      @articles = articles  
      @last_article_id =last_article_id
      @user_id=user_id
end


end
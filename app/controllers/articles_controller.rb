class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :authenticate_user, :except => [:scrape]

  # GET /articles
  # GET /articles.json
  def index
    #Pagination of articles
    @articles = Article.page(params[:page]).per(10)
    # For Search
    if params[:search]
      keywords = params[:search].split
      art = Array.new
      keywords.each do |key|
        if key == keywords[0]
          @weight_hash = Article.weighting(key)
        else 
          seq_hash = Article.weighting(key)
          @weight_hash = Article.hash_compare(@weight_hash, seq_hash)
        end
      end
      art_id = @weight_hash.keys
      art_id.each{|e| art<<Article.find(e)}
      @articles = Kaminari.paginate_array(art.reverse).page(params[:page]).per(10)
    end
  end
  def interest
    @user = current_user
    @articles = Article.tagged_with(@user.tag_list, :any => true).page(params[:page]).per(10)
  end
  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
  #Scraping process
  def scrape       
      #Scrape all the sources
      News::Importer.get_sources.each_pair do |key, importer_klass|
      @articles =  News::Importer.scrape_source importer_klass
      #Save articles    
      success = @articles.map(&:save)             
      end  
      #tagging process
      tag_articles
      render :layout => false
  end    
  
  def get_articles_to_tag
  # Getting articles that don't have tags
  return Article.joins(%Q{LEFT JOIN taggings ON taggings.taggable_id=articles.id AND taggings.taggable_type='Article'}).where('taggings.id IS NULL')
  end

  def tag_articles
     articles = get_articles_to_tag    
     tag = Tag.new     
     
     articles.each do |article|
       logger.debug "Articles to tag"     
       tags_articles = ""
       text_to_tag = article.summary!=nil ? article.summary : '' + ' ' + article.title!=nil ? article.title : ''
       tags_articles = tag.get_tags(text_to_tag)
       article.tag_list=tags_articles
       result = article.save       
     end
    #@result = articles.map(&:save)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:article).permit(:source, :title, :summary, :publish_date, :author, :url, :img_url)
  end  
end

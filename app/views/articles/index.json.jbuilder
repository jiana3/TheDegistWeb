json.array!(@articles) do |article|
  json.extract! article, :id, :source, :title, :summary, :publish_date, :author, :url, :img_url
  json.url article_url(article, format: :json)
end

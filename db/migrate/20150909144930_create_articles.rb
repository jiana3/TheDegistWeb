class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :source
      t.string :title
      t.text :summary
      t.date :publish_date
      t.string :author
      t.string :url
      t.string :img_url

      t.timestamps null: false
    end
  end
end

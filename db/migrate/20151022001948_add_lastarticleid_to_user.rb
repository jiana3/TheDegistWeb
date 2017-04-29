class AddLastarticleidToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_article_id, :integer
  end
end

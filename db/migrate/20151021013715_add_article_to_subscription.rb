class AddArticleToSubscription < ActiveRecord::Migration
  def change
    add_reference :subscriptions, :article, index: true, foreign_key: true
  end
end

class AddIssubscriberToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_subscriber, :boolean
  end
end

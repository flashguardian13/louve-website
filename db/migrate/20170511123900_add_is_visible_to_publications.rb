class AddIsVisibleToPublications < ActiveRecord::Migration[5.0]
  def change
    add_column :publications, :is_visible, :boolean
    add_column :reviews, :is_visible, :boolean
    add_column :retailers, :is_visible, :boolean
  end
end

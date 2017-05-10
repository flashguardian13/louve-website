class AddIsVisibleToExternalLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :external_links, :is_visible, :boolean
  end
end

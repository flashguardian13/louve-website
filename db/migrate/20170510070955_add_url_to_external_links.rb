class AddUrlToExternalLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :external_links, :url, :string
    add_column :external_links, :title, :string
    add_column :external_links, :description, :string
  end
end

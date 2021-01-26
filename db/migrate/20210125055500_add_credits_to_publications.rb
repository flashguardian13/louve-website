class AddCreditsToPublications < ActiveRecord::Migration[5.2]
  def change
    add_column :publications, :credits, :string
    add_column :publications, :publish_date, :date
    add_column :publications, :publisher, :string
    add_column :publications, :publisher_url, :string
  end
end

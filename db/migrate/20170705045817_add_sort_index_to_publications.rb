class AddSortIndexToPublications < ActiveRecord::Migration[5.0]
  def change
    add_column :publications, :sort_index, :Integer
  end
end

class CreatePublications < ActiveRecord::Migration[5.0]
  def change
    create_table :publications do |t|
      t.string :title
      t.string :image
      t.string :short_description
      t.string :long_description

      t.timestamps
    end
  end
end

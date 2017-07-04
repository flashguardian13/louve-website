class CreateRetailers < ActiveRecord::Migration[5.0]
  def change
    create_table :retailers do |t|
      t.belongs_to :publication, index: true
      t.string :name
      t.string :link

      t.timestamps
    end
  end
end

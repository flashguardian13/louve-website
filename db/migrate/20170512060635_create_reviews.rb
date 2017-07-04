class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.belongs_to :publication, index: true
      t.string :quote
      t.string :attribution

      t.timestamps
    end
  end
end

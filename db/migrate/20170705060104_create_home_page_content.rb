class CreateHomePageContent < ActiveRecord::Migration[5.0]
  def change
    create_table :home_page_contents do |t|
      t.string :content

      t.timestamps
    end
  end
end

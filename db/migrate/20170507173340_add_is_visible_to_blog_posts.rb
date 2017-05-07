class AddIsVisibleToBlogPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :blog_posts, :is_visible, :boolean
  end
end

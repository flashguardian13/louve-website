class AddAbstractToBlogPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :blog_posts, :abstract, :string, default: nil
  end
end

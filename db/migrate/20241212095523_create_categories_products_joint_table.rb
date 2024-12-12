class CreateCategoriesProductsJointTable < ActiveRecord::Migration[8.0]
  def change
    create_table :categories_products, id: false do |t|
      t.references :category, null: false, foreign_key: true, index: true
      t.references :product, null: false, foreign_key: true, index: true
    end

    add_index :categories_products, [ :category_id, :product_id ], unique: true
  end
end

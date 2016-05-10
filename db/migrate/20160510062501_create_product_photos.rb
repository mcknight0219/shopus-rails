class CreateProductPhotos < ActiveRecord::Migration
  def change
    create_table :product_photos do |t|
      t.string :format
      t.string :temp_path
      t.boolean :stored_remote
      t.string :media_id
      t.references :good, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

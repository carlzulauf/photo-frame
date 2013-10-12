class CreatePhotos < ActiveRecord::Migration
  def up
    create_table :photos do |t|
      t.string :path
      t.string :token
      t.integer :file_size
      t.integer :boost, default: 0
      t.timestamps
    end
    add_index :photos, :token
  end

  def down
    drop_table :photos
  end
end

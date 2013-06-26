class SimpleNoticeMigration < ActiveRecord::Migration
  def self.up
    create_table :notices do |t|
      t.string  :what
      t.string  :scene
      t.integer :user_id
      t.text    :moel_id
      t.string  :model_type
      t.text    :data
      t.boolean :is_read
      t.timestamps
    end
  end

  def self.down
    drop_table :notices
  end
end
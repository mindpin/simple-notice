class UserMigration < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :users
  end
end

class MigrationHelper
  def self.up
    UserMigration.up
    SimpleNoticeMigration.up
  end

  def self.down
    UserMigration.down
    SimpleNoticeMigration.down
  end
end
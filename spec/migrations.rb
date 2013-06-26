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

class QuestionMigration < ActiveRecord::Migration
  def self.up
    create_table :questions, :force => true do |t|
      t.string :name
      t.integer :creator_id
    end
  end

  def self.down
    drop_table :questions
  end
end

class MigrationHelper
  def self.up
    QuestionMigration.up
    UserMigration.up
    SimpleNoticeMigration.up
  end

  def self.down
    QuestionMigration.down
    UserMigration.down
    SimpleNoticeMigration.down
  end
end
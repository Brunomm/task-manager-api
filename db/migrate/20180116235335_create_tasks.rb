class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :description
      t.boolean :done, default: false
      t.datetime :deadline

      t.timestamps
    end
  end
end

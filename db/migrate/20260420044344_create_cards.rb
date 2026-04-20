class CreateCards < ActiveRecord::Migration[8.1]
  def change
    create_table :cards do |t|
      t.string :name, null: false
      t.string :pinyin, null: false
      t.string :uuid, null: false

      t.timestamps
    end

    add_index :cards, :uuid, unique: true
  end
end

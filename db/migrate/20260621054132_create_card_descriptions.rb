class CreateCardDescriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :card_descriptions do |t|
      t.references :card, null: false, foreign_key: true
      t.string :content

      t.timestamps
    end
  end
end

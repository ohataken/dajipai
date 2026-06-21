class AddUniqueIndexToCardDescriptionsCardId < ActiveRecord::Migration[8.1]
  def change
    add_index :card_descriptions, :card_id, unique: true
  end
end

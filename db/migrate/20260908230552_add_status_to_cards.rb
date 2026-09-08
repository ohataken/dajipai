class AddStatusToCards < ActiveRecord::Migration[8.1]
  def up
    add_column :cards, :status, :string, null: false, default: "draft"
    add_index :cards, :status

    # Cards created before the draft feature were all playable, so keep them published.
    execute "UPDATE cards SET status = 'published'"
  end

  def down
    remove_index :cards, :status
    remove_column :cards, :status
  end
end

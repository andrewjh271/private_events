class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.date :date, null: false
      t.string :location, null: false
      t.text :description
      t.references :host, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :events, :name, unique: true
  end
end

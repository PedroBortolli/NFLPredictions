class CreatePredictions < ActiveRecord::Migration[5.1]
  def change
    create_table :predictions do |t|
      t.string :user
      t.string :gameId
      t.string :winner

      t.timestamps
    end
  end
end

class AddTimestampsToAnswerChoices < ActiveRecord::Migration[6.0]
  def change
    add_column :answer_choices, :created_at, :datetime, null: false
    add_column :answer_choices, :updated_at, :datetime, null: false
  end
end

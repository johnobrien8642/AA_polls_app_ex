

class AnswerChoice < ApplicationRecord
    validates :body, presence: :true
    after_destroy :log_destroy_action

    belongs_to :question,
      class_name: :Question,
      foreign_key: :question_id,
      primary_key: :id

    has_many :responses,
      class_name: :Response,
      foreign_key: :answer_choice_id,
      primary_key: :id

    def log_destroy_action
      puts 'Answer Choice destroyed'
    end
end
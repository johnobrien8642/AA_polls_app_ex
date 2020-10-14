require 'byebug'

class Response < ApplicationRecord
    

    belongs_to :respondent,
      class_name: :User,
      foreign_key: :respondent_id,
      primary_key: :id

    belongs_to :answer_choice,
      class_name: :AnswerChoice,
      foreign_key: :answer_choice_id,
      primary_key: :id

    has_one :question,
      through: :answer_choice,
      source: :question

    validate :not_duplicate_response, unless: -> { answer_choice.nil?}  

    def not_duplicate_response
      if respondent_already_answered?
          errors[:respondent_id] << 'cannot vote twice for question'
      end
    end

    def respondent_already_answered?
    #   sibling_responses.exists?(respondent_id: self.respondent_id)
    #   debugger
      respondents = sibling_responses
      respondents.each do |response|
        return true if response.respondent_id == self.id
      end
    end

    def sibling_responses
      question.responses.where.not(id: self.id)
    end
end
require 'byebug'

class Response < ApplicationRecord
    after_destroy :log_destroy_action
    
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
    validate :author_cannot_respond_to_own_poll, unless: -> { answer_choice.nil? }

    def not_duplicate_response
      if respondent_already_answered?
          errors[:respondent_id] << 'cannot vote twice for question'
      end
    end

    def respondent_already_answered?
    # Answer from solution
      sibling_responses.exists?(respondent_id: self.respondent_id)
    end

    def sibling_responses
      question.responses.where.not(id: self.id)
    end

    def author_cannot_respond_to_own_poll
      poll_author_id = self.answer_choice.question.poll.user_id

      if poll_author_id == self.respondent_id
        errors[:respondent_id] << 'cannot be poll author'
      end
    end

    def does_not_respond_to_own_poll_1_query
        poll_author_id = Poll
          .joins(questions: :answer_choices)
          .where('answer_choices.id = ?', self.answer_choice_id)
          .pluck('polls.user_id')
          .first

        if poll_author_id == self.respondent_id
          errors[:respondent_id] << 'cannot be poll author'
        end
    end

    def log_destroy_action
      puts 'Response destroyed'
    end
end
require 'byebug'

class Question < ApplicationRecord
    validates :body, presence: :true

    belongs_to :poll,
      class_name: :Poll,
      foreign_key: :poll_id,
      primary_key: :id

    has_many :answer_choices,
      class_name: :AnswerChoice,
      foreign_key: :question_id,
      primary_key: :id

    has_many :responses,
      through: :answer_choices,
      source: :responses

    def results_2_queries
      # # N + 1 solution
      # count_hash = {}
      # choices = self.answer_choices
      # choices.each do |choice|
      #     count_hash[choice.body] = choice.responses.count
      # end
      # count_hash  
      #2 - queries, responses pre-fetched
      count_hash = {}
      self.answer_choices.includes(:responses).each do |ac|
          count_hash[ac.body] = ac.responses.length
      end
      count_hash
    end

    def results_1_query_SQL
    # # solution version with .inject
    # acs = AnswerChoice.find_by_sql([<<-SQL, id])
    #   SELECT
    #     answer_choices.body, COUNT(responses.id) AS num_responses
    #   FROM
    #     answer_choices
    #     LEFT OUTER JOIN responses
    #       ON answer_choices.id = responses.answer_choice_id
    #   WHERE
    #     answer_choices.question_id = ?
    #   GROUP BY
    #     answer_choices.id
    # SQL

    # acs.inject({}) do |results, ac|
    #   results[ac.body] = ac.num_responses; results
    # end

    acs = AnswerChoice.find_by_sql([<<-SQL, id])
        SELECT
          answer_choices.body, COUNT(responses.id) AS results
        FROM
          answer_choices
        LEFT JOIN
          responses ON responses.answer_choice_id = answer_choices.id
        WHERE 
          answer_choices.question_id = ?
        GROUP BY
          answer_choices.id
      SQL

      count_hash = {}
      acs.each do |result|
        count_hash[result.body] = result.results
      end
      count_hash
    end
end
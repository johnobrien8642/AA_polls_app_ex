

class User < ApplicationRecord
    validates :username, presence: :true, uniqueness: :true
    
    has_many :authored_polls,
      class_name: :Poll,
      foreign_key: :user_id,
      primary_key: :id

    has_many :responses,
      class_name: :Response,
      foreign_key: :respondent_id,
      primary_key: :id

    def completed_polls_sql
      Poll.find_by_sql([<<-SQL, id])
        SELECT
          polls.*
        FROM
          polls
        JOIN
          questions ON polls.id = questions.poll_id
        JOIN
          answer_choices ON questions.id = answer_choices.question_id
        LEFT OUTER JOIN (
            SELECT
              *
            FROM
              responses
            WHERE 
              respondent_id = #{self.id}
        ) AS responses ON answer_choices.id = responses.answer_choice_id
        GROUP BY 
          polls.id
        HAVING
          COUNT(DISTINCT questions.id) = COUNT(responses.*)
      SQL
    end

    
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do
    User.destroy_all
    Poll.destroy_all
    Question.destroy_all
    Response.destroy_all
    AnswerChoice.destroy_all

    u1 = User.create!(username: "BigBill")
    u2 = User.create!(username: "Lefty")
    u3 = User.create!(username: "Avalanche")

    poll1 = Poll.create!(user_id: u1.id, title: "Candy Mechanics")

    q1 = Question.create!(poll_id: poll1.id, body: 'How many licks to the center of a tootsie pop?')
        ac1 = AnswerChoice.create!(question_id: q1.id, body: '1 licks')
        ac2 = AnswerChoice.create!(question_id: q1.id, body: '2 licks')
        ac3 = AnswerChoice.create!(question_id: q1.id, body: '3 licks')

    q2 = Question.create!(poll_id: poll1.id, body: 'Which candy bar is the best?')
        ac4 = AnswerChoice.create!(question_id: q2.id, body: 'Hershey''s Chocolate Bar')
        ac5 = AnswerChoice.create!(question_id: q2.id, body: 'Reese''s Fast Break')
        ac6 = AnswerChoice.create!(question_id: q2.id, body: 'Snickers')
    
    resp1 = Response.create!(respondent_id: u2.id, answer_choice_id: ac1.id)
    resp2 = Response.create!(respondent_id: u3.id, answer_choice_id: ac3.id)
    resp3 = Response.create!(respondent_id: u1.id, answer_choice_id: ac3.id)
    resp4 = Response.create!(respondent_id: u1.id, answer_choice_id: ac5.id)
end
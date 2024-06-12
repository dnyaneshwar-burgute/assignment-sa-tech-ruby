require "pstore" # https://github.com/ruby/pstore

STORE_NAME = "tendable.pstore"
@store = PStore.new(STORE_NAME)

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

# TODO: FULLY IMPLEMENT
def do_prompt
  # Hash Used to store the answers for each questions
  answers = {}
  # Ask each question and get an answer from the user's input.
  QUESTIONS.each_key do |question_key|
    print QUESTIONS[question_key]
    ans = gets.chomp.downcase rescue nil
    answers[question_key] = ans
  end
  # Use store to store the answers
  @store.transaction do
    @store[:answers] = answers
  end
end

def do_report
  answers = nil

  @store.transaction(true) do
    answers = @store[:answers]
  end

  return unless answers

  total_questions = QUESTIONS.size
  yes_count = answers.values.count('yes') + answers.values.count('y')

  rating = (yes_count.to_f / total_questions * 100).round(2)
  puts "Rating for this run: #{rating}%"

end

do_prompt
do_report

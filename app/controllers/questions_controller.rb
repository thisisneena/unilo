class QuestionsController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to Question.first
  end

  def show
    @question = Question.find(params[:id])
    @jacs = JacsCode.all.map(&:name) if @question.question_type == "jacs"
  end

  def next
    save_question_response
    redirect_to @question.next
  end

  def last
    save_question_response
    redirect_to @question.prev
  end
  def complete
    current_user.elo_scores.each{|e| e.delete}

    current_user.preferences[:jacs_course_id] = "001"

    Course.all.select do |course|
      course.jacs == current_user.preferences[:jacs_course_id]
    end.inject({}) do |courses, c|
      courses[c] = current_user.preferences.inject(0) do |score, (k, v)|
        k = k.to_s
        if (!v.blank? && !c.get_attribute(k).blank? && v.is_a?(Float))
          score += eval("c.#{k}")*v
        end
        score
      end
      courses
    end.sort_by do |course, score|
      score
    end.first(20).each do |(c, s)|
      e = EloScore.new(university: c.university, user: current_user, score: (100 + s))
      e.save
    end

    redirect_to elos_path
  end 

  private
  def save_question_response
    @question = Question.find(params[:id])
    if @question.question_type == "slider"
      current_user.preferences[@question.identifier.to_sym] = params[:response].to_i/10
    else
      current_user.preferences[@question.identifier.to_sym] = params[:response]
    end
    current_user.save 
  end
end

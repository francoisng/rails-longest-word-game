require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)] }.join
  end
  
  def score
    @word = params[:word]
    @letters = params[:letters]
    if @included = grid_inclusion?(@word, @letters)
      if @english_word = api_answer(@word)["found"]
        @score = api_answer(@word)["length"]
      end
    end
  end

  private
  
  def grid_inclusion?(attempt, grid)
    attempt_array = attempt.downcase.split('')
    grid_array = grid.downcase.split('')
    inter_array = (attempt_array & grid_array).flat_map { |n| [n] * [attempt_array.count(n), grid_array.count(n)].min }
    inter_array.sort == attempt_array.sort
  end

  def api_answer(attempt)
    url = 'https://wagon-dictionary.herokuapp.com/' + attempt
    api_answer = open(url).read
    JSON.parse(api_answer)
  end

end

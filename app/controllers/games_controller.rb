class GamesController < ApplicationController
  require 'json'
  require 'open-uri'

  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @letters = params[:letters]
    @guess = params[:guess]
    dict_check = dictionary_check(@guess)
    contains = contains_all?(@guess, @letters)
    @result = check_word(dict_check, contains, @guess)
  end

  def dictionary_check(guess)
    url = "https://wagon-dictionary.herokuapp.com/#{guess}"
    user_serialised = open(url).read
    user = JSON.parse(user_serialised)
    user['found']
  end

  def contains_all?(guess, letters)
    try = guess.chars.all? do |letter|
      guess.count(letter) <= letters.count(letter)
    end
    try
  end

  def check_word(dict_check, contains, guess)
    case
    when contains && dict_check
      result = "Congratulations '#{guess}'' is a valid word!"
    when contains && !dict_check
      result = "'#{guess}' is not an english word."
    when !contains
      result = "'#{guess}' is not in the grid."
    end
    result
  end
end

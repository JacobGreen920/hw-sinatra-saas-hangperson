class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end
  
  def guess(letter)
    if letter == nil
      throw ArgumentError
    elsif not /[a-z]/ =~ letter.downcase
      throw ArgumentError
    end
    if self.word.include?(letter.downcase) and not self.guesses.include?(letter.downcase)
      self.guesses = self.guesses + letter
      return true
    elsif not self.word.include?(letter.downcase) and not self.wrong_guesses.include?(letter.downcase)
      self.wrong_guesses = self.wrong_guesses + letter
      return true
    end
    return false
  end
  
  def word_with_guesses
    display = ""
    self.word.each_char { |let|
      if self.guesses.include?(let.downcase)
        display = display + let
      else
        display = display + "-"
      end
    }
    return display
  end
  
  def check_win_or_lose
    if not self.word_with_guesses.include?('-')
      return :win
    elsif self.wrong_guesses.length >= 7
      return :lose
    else
      return :play
    end
  end
end

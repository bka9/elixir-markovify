defmodule SplitterTest do
  use ExUnit.Case
  doctest Markovify.Splitter
  
  test "split a simple sentence" do
    sentences = Markovify.Splitter.split_into_sentences("Football goals are attained not by strength but by perseverance. Football is like life - it requires perseverance, self-denial, hard work, sacrifice, dedication and respect for authority.")
    assert sentences == ["Football goals are attained not by strength but by perseverance.", "Football is like life - it requires perseverance, self-denial, hard work, sacrifice, dedication and respect for authority."]
  end

  test "sentences with abbreviations" do
    sentences = Markovify.Splitter.split_into_sentences("Football goals are attained not by strength but by perseverance. Mr. Lombardi is a good man.")
    assert sentences == ["Football goals are attained not by strength but by perseverance.", "Mr. Lombardi is a good man."]
  end
end

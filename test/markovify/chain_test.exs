defmodule ChainTest do
  use ExUnit.Case
  doctest Markovify.Chain

  test "short string returns map" do
    {model,_,_,_,_,_} = Markovify.Chain.build([["Football","goals","are","attained","not","by","strength","but","by","perseverance"]], 2)
    assert Enum.find(model,fn({{key,_},_}) -> key == {"__BEGIN__","__BEGIN__"} end) == {{{"__BEGIN__","__BEGIN__"},"Football"}, 1}
  end
  test "multiple keys" do
    {model,_,_,_,_,_} = Markovify.Chain.build([["Football","goals","are","attained","not","by","strength","but","by","perseverance"],["Football"]], 2)
    assert Enum.find(model,fn({{key,_},_}) -> key == {"__BEGIN__","__BEGIN__"} end) == {{{"__BEGIN__","__BEGIN__"},"Football"}, 2}
  end
  test "creating a sentence from sample of one" do
    chain = Markovify.Chain.build([["Football","goals","are","attained","not","by","strength","but","by","perseverance"]], 2)
    {n_chain, sentence} = Markovify.Chain.walk(chain)
    assert n_chain == Tuple.insert_at(Tuple.delete_at(chain,2),2,{"by","perseverance"})
    assert sentence == ["Football","goals","are","attained","not","by","strength","but","by","perseverance"]
  end
  test "creating a sentence from sample of two" do
    chain = Markovify.Chain.build([["Football","goals","are","attained","not","by","strength","but","by","perseverance"],["Football","is","life"]], 2)
    {n_chain, sentence} = Markovify.Chain.walk(chain)
    last = Enum.take(sentence,-2)
    assert n_chain == Tuple.insert_at(Tuple.delete_at(chain,2),2,List.to_tuple(last))
  end
end

defmodule Markovify.Splitter do
  @splitter ~r/(?<!\w\.\w.)(?<![A-Z][a-z]\.)(?<=\.|\?|!)\s+/u

  def split_into_sentences(text), do: text |> String.split(@splitter)
end

defmodule Markovify.Splitter do
  @moduledoc """
    Markovify.Splitter is a default implementation for splitting text into arrays of sentences.
  """
  @splitter ~r/(?<!\w\.\w.)(?<![A-Z][a-z]\.)(?<=\.|\?|!)\s+/u

  @doc """
    splits a body of text into an array of sentences using [Sentence Boundary Disambiguation](https://en.wikipedia.org/wiki/Sentence_boundary_disambiguation)
  """
  @spec split_into_sentences(String.t)::[String.t]
  def split_into_sentences(text), do: text |> String.split(@splitter)
end

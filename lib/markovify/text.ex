defmodule Markovify.Text do
  @default_max_overlap_ratio 0.7
  @default_max_overlap_total 15
  @default_tries 10
  @begin "__BEGIN__"

  def model(text, fun \\ &Markovify.Splitter.split_into_sentences/1, text_size \\ 2) do
    runs = generate_corpus(fun.(text))
    Markovify.Chain.build(runs, text_size)
  end

  defp generate_corpus(sentences) do
    passing = Enum.filter(sentences, fn(sentence) -> !(Regex.match?(~r/(^')|('$)|\s'|'\s|[\"(\(\)\[\])]/,sentence)) end)
    Enum.map(passing, fn(sentence) -> Regex.split(~r/\s+/,sentence) end)
  end

  def make_sentence(chain, config \\ {@default_tries, @default_max_overlap_ratio, @default_max_overlap_total}) do
    {tries, max_overlap_ratio, max_overlap_total} = config
    check(chain,max_overlap_ratio,max_overlap_total,tries)
  end

  defp check(chain, _, _, 0), do: {chain,:empty}
  defp check({_,_,state, _, _,_} = chain, max_overlap_ratio, max_overlap_total, tries) do
     prefix = prefix(state)
    {_, words} = Markovify.Chain.walk(chain)
    sentence = prefix ++ words
    cond do
      test_sentence_output(chain, sentence, max_overlap_ratio, max_overlap_total) -> {chain, Enum.join(sentence," ")}
      true -> check(chain,max_overlap_ratio,max_overlap_total,tries-1)
    end
  end

  defp prefix({}) do
    []
  end
  defp prefix(state) do
    case elem(state,0) do
      @begin -> Tuple.to_list(Tuple.delete_at(state,0))
      _ -> Tuple.to_list(state)
    end
  end

  defp test_sentence_output({_,_,_,_,_,initial_text}, words, max_overlap_ratio, max_overlap_total) do
    overlap_ratio = Float.round(length(words)*max_overlap_ratio, 0)
    overlap_max = Enum.max([overlap_ratio, max_overlap_total])
    overlap_over = overlap_max + 1
    gram_count = Enum.max([(length(words) - overlap_over), 1])
    grams = create_grams([], words, overlap_over, gram_count)
    find_grams(grams, initial_text)
  end

  defp find_grams(grams, _) when length(grams) == 0 do
    true
  end
  defp find_grams([gram|rest], text) do
    case check_gram(gram,text) do
      {:notfound} -> find_grams(rest,text)
      {:found,_} -> false
    end
  end

  defp check_gram(gram, [_|rest] = text) do
    cond do
      length(text) < length(gram) -> {:notfound}
      gram == Enum.slice(text, 0..length(gram)-1) -> {:found, gram}
      true -> check_gram(gram,rest)
    end
  end

  defp create_grams(grams, _, _, 0), do: grams
  defp create_grams(grams,words, overlap_over, gram_count) do
    index = gram_count - 1
    create_grams(grams ++ [ Enum.slice(words, index..(index+overlap_over)) ], words, overlap_over, index)
  end
end

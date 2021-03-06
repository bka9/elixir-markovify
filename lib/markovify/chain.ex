defmodule Markovify.Chain do
  @moduledoc """
    Markovify.Chain is the model that represents the distribution and states of a given sentence structure.
  """
  @begin "__BEGIN__"
  @finish "__END__"

  @doc """
    Builds the model of the sentences with the state size.
  """
  @spec build([[String.t]],number)::{{[{{Tuple.t,String.t},number}],number,Tuple.t,[String.t],[number]}, String.t}
  def build([head | _] = corpus, state_size) when is_list(head) do
    model = Enum.map(Enum.group_by(Enum.flat_map(corpus, fn(run) ->
      items = List.duplicate(@begin,state_size) ++ run ++ [ @finish ]
      Enum.map(Enum.with_index(run++[@finish]), fn({_, index}) ->
        state = List.to_tuple(Enum.slice(items,index..(index+state_size-1)))
        follow = Enum.at(items,index+state_size)
        {state, follow}
      end)
    end),
    fn(x) -> x end), fn({{state,follow}, array}) -> {{state,follow}, length(array)} end )
    Tuple.append(precompute_begin_state(model,state_size), List.flatten(corpus))
  end

  @doc """
    To optimize the algorithm this caches the choices that follow the beginning state and the distribution of these choices.
  """
  @spec precompute_begin_state([{{Tuple.t,String.t},number}], number)::{[{{Tuple.t, String.t},number}],number,Tuple.t,[String.t],[number]}
  defp precompute_begin_state(model,state_size) do
    begin_state = Tuple.duplicate(@begin,state_size)
    begin_choices = Enum.map(Enum.filter(model, fn({{state,_},_}) -> state == begin_state end), fn({{_,follow},_}) -> follow end)
    {distrib,_} = Enum.map_reduce(Enum.filter(model, fn({{state,_},_}) -> state == begin_state end), 0, fn({{_,_},count},acc) -> {acc + count, acc + count} end)
    {model, state_size, {}, begin_choices, distrib}
  end

  @doc """
    Given the chain select a random word from the choices and distribution of the current state.
  """
  @spec move({[{{Tuple.t, String.t}, number}], number, Tuple.t, [String.t], [number],[String.t]})::{{[{{Tuple.t, String.t}, number}], number, Tuple.t, [String.t], [number],[String.t]}, String.t}
  def move({model, state_size, state, begin_choices, begin_distribution, rejoined_text} = chain) do
    choices_weights = cond do
      state == Tuple.duplicate(@begin,state_size) -> {begin_choices, begin_distribution}
      true -> {c, {dist,_}} = {Enum.map(Enum.filter(model,fn({{s,_},_}) -> s == state end), fn({{_,follow},_}) -> follow end),Enum.map_reduce(Enum.filter(model, fn({{s,_},_}) -> s == state end), 0, fn({{_,_},count},acc) -> {acc + count, acc + count} end)}
            {c, dist}
    end
    case choices_weights do
      {[],[]} -> {chain,[]}
      {c, w} -> r = Enum.random(0..Enum.at(w,-1))
                selection = Enum.at(c,Enum.find_index(w,fn(x) -> r <= x end))
                {chain, selection}
    end
  end

  @doc """
    Generate a sentence from the markov chain
  """
  @spec gen({[{{Tuple.t, String.t}, number}], number, Tuple.t, [String.t], [number],[String.t]},[String.t])::{{[{{Tuple.t, String.t}, number}], number, Tuple.t, [String.t], [number],[String.t]}, [String.t]}
  def gen({model,state_size,{},choices,dist,text},s_array\\[]) do
    gen({model,state_size,Tuple.duplicate(@begin,state_size),choices,dist,text},s_array)
  end
  def gen(chain, s_array) do
    case move(chain) do
      {n_chain, []} -> {n_chain, s_array}
      {n_chain, @finish} -> {n_chain, s_array}
      {{model,state_size, state, b_choices, b_distrib, r_text}, next_word} -> gen({model,state_size,Tuple.delete_at(Tuple.append(state,next_word),0),b_choices,b_distrib, r_text}, s_array ++ [ next_word ])
    end
  end
  
  @doc """
    Generates a sentence from the markov chain
  """
  @spec walk({{[{{Tuple.t, String.t}, number}], number, Tuple.t, [String.t], [number],[String.t]},[String.t]})::{{[{{Tuple.t, String.t}, number}], number, Tuple.t, [String.t], [number],[String.t]},[String.t]}
  def walk(chain) do
    Markovify.Chain.gen(chain)
  end
end

# elixir-markovify

Inspired by the python package [Markovify](https://github.com/jsvine/markovify), this library uses [Markov Chain](https://en.wikipedia.org/wiki/Markov_chain) theory to take a body of text and create a new sentence based off of that text.

The idea of a markov chain is that given a state there is not equal probability of the next state. As the algorithm decides the next state to move to it will use this distributed probability to go down a more random path.

## Example

```elixir
  chain = Markovify.Text.model("<sample text here>")
  Markovify.Text.make_sentence(chain)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `markovify` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:markovify, "~> 0.1.0"}]
    end
    ```

  2. Ensure `markovify` is started before your application:

    ```elixir
    def application do
      [applications: [:markovify]]
    end
    ```


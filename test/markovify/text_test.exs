defmodule TextTest do
  use ExUnit.Case
  doctest Markovify.Text

  @lorum_ipsum_text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In euismod facilisis arcu, vitae facilisis neque congue eu. Fusce quis augue nec felis dignissim maximus sit amet in lectus. Sed a vulputate eros, eu bibendum felis. Fusce sagittis tempus augue quis accumsan. Vivamus luctus tincidunt massa, semper ullamcorper felis commodo quis. Aliquam erat volutpat. In nec elit ut enim porta laoreet. In hac habitasse platea dictumst. Maecenas condimentum erat at quam ultrices rutrum. Duis eu elit id eros sodales maximus. Vestibulum eget sapien varius, porta justo eu, porttitor dui. Sed consequat ipsum sed ante lobortis, eget sollicitudin sapien lacinia. Nam pretium quam et ex tristique, sit amet posuere nunc porttitor. Fusce blandit felis at ex egestas vulputate. Integer viverra convallis cursus.
  Duis pharetra a lectus non aliquet. Fusce gravida et velit molestie blandit. Integer metus augue, feugiat et porta eu, feugiat eu libero. Aliquam in suscipit sem. Aenean condimentum elit id gravida rutrum. Quisque tempus leo vel eros aliquam, vel iaculis velit euismod. Integer aliquet erat at malesuada congue.
  Nam non tincidunt sem. Donec lacus ipsum, sagittis vitae ultrices vitae, ullamcorper eu mauris. Nulla facilisi. Duis pharetra, turpis ac fermentum pretium, est leo dapibus felis, id scelerisque lorem nulla pellentesque elit. Vestibulum nunc urna, consectetur quis gravida eget, ultricies ut sapien. Sed eget tempor orci, sit amet pellentesque ligula. Integer elementum dui et erat imperdiet luctus. Suspendisse non eros sed erat viverra malesuada ut et nulla. Cras gravida non dui id tempor.
  Donec in ex finibus, laoreet quam vel, efficitur dui. Integer iaculis erat vel imperdiet sollicitudin. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam aliquam dolor at felis varius vehicula. Aliquam nec nisl tempor, tempus leo ut, tincidunt nisi. Nunc ac consequat massa. Etiam ut sagittis magna, non egestas mauris. Aenean purus mi, viverra at ultricies ac, dapibus sed libero. Aenean pellentesque sodales sem efficitur mattis. Donec ligula nisi, malesuada non accumsan ac, ullamcorper at lacus. Sed rhoncus lorem ex, nec fringilla tellus condimentum non. Quisque egestas libero vel mauris pharetra convallis. Donec vitae est nec orci egestas malesuada. Aliquam molestie suscipit metus.
  Ut at dolor diam. Ut nisi nunc, fermentum eu gravida eget, pellentesque dignissim ante. Donec vulputate pellentesque neque, luctus condimentum turpis varius ut. Aliquam erat volutpat. Fusce iaculis facilisis velit, et porta leo sagittis faucibus. Nullam eleifend dolor in ex mollis, sed congue purus hendrerit. Vivamus nec posuere libero. Nulla facilisi. Sed blandit mattis ex sit amet condimentum. Duis sit amet auctor quam."

  test "Build a model from simple text" do
    chain = Markovify.Text.model("This is a simple sentence",fn(x) -> [x] end)
    assert chain == {[{{{"This", "is"}, "a"}, 1}, {{{"__BEGIN__", "This"}, "is"}, 1},
      {{{"__BEGIN__", "__BEGIN__"}, "This"}, 1}, {{{"a", "simple"}, "sentence"}, 1},
      {{{"is", "a"}, "simple"}, 1}, {{{"simple", "sentence"}, "__END__"}, 1}], 2, {}, ["This"], [1],
    ["This", "is", "a", "simple", "sentence"]}
  end
  test "too similar to original sentence returns nothing" do
    chain = Markovify.Text.model("This is a simple sentence",fn(x) -> [x] end)
    {_,sentence} = Markovify.Text.make_sentence(chain)
    assert sentence == :empty
  end
  test "a complex text generates a unique sentence" do
    chain = Markovify.Text.model(@lorum_ipsum_text)
    {_,sentence} = Markovify.Text.make_sentence(chain)
    IO.inspect sentence
    assert sentence != :empty
  end
end

defmodule StoneBank.Cldr do
  @moduledoc """
  Cldr configuration to get the local language
  """
  use Cldr,
    locales: ["en", "br"],
    default_locale: "br",
    providers: [Cldr.Number, Money]
end

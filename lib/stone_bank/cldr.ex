defmodule StoneBank.Cldr do
  use Cldr,
    locales: ["en", "br"],
    default_locale: "br",
    providers: [Cldr.Number, Money]
end

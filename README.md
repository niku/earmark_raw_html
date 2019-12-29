# EarmarkRawHtml

If you write html in markdown and convert to html using earmark's [AST feature](https://github.com/pragdave/earmark#earmarkas_ast2), the html in markdown is escaped.
This library keeps raw html when it is converted.

Status: **EXPERIMENTAL**

## Installation

```elixir
def deps do
  [
    {:earmark_raw_html, github: "niku/earmark_raw_html"}
  ]
end
```

## Usage

Note: When you use this library, you should add an option `pure_links: false` to `Earmark.as_ast/2` to avoid [adding auto link by earmak](https://hexdocs.pm/earmark/1.4.3/Earmark.html#as_html/2).

```elixir
markdown = """
<a href="http://example.com/">example link</a>

[example link md style](http://example.com/)
"""
{:ok, ast, []} = Earmark.as_ast(markdown, pure_links: false)
ast |> Earmark.Transform.transform() |> IO.puts()
# <p>
#   &lt;a href=&quot;http://example.com/&quot;&gt;example link&lt;/a&gt;
# </p>
# <p>
#   <a href="http://example.com/">
#     example link md style
#   </a>
# </p>

ast |> EarmarkRawHtml.melt_raw_html_into_ast() |> Earmark.Transform.transform() |> IO.puts()
# <p>
#   <a href="http://example.com/">
#     example link
#   </a>
# </p>
# <p>
#   <a href="http://example.com/">
#     example link md style
#   </a>
# </p>
```

## LICENSE

MIT. Check the [LICENSE](LICENSE) file for more information.

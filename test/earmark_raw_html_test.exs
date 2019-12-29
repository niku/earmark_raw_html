defmodule EarmarkRawHtmlTest do
  use ExUnit.Case
  doctest EarmarkRawHtml

  test "keep raw html when it is converted" do
    doc = """
    This is a regular paragraph.

    <table>
        <tr>
            <td>Foo</td>
        </tr>
    </table>

    <a href="http://example.com">link to example</a>

    This is another regular paragraph.
    """

    expected = """
    <p>
      This is a regular paragraph.
    </p>
    <table>
          <tr>          <td>Foo</td>      </tr></table>
    <p>
      <a href="http://example.com">
        link to example
      </a>
    </p>
    <p>
      This is another regular paragraph.
    </p>
    """

    {:ok, ast, []} = Earmark.as_ast(doc, pure_links: false)

    actual =
      ast
      |> EarmarkRawHtml.melt_raw_html_into_ast()
      |> Earmark.Transform.transform()

    assert expected == actual
  end
end

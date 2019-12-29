defmodule EarmarkRawHtml do
  @moduledoc """
  Documentation for `EarmarkRawHtml`.
  """

  @doc """
  Melts raw html into AST

  The purpose is to keep the html without escaping when it is converted.
  """
  def melt_raw_html_into_ast(ast) do
    do_melt_raw_html_into_ast(ast, [], [])
  end

  @doc false
  def do_melt_raw_html_into_ast(_ast, _ancestor_tags, _result)

  def do_melt_raw_html_into_ast([], _ancestor_tags, result), do: Enum.reverse(result)

  def do_melt_raw_html_into_ast([{tag, atts, ast} | rest], ancestor_tags, result) do
    do_melt_raw_html_into_ast(rest, [tag | ancestor_tags], [
      {tag, atts, do_melt_raw_html_into_ast(ast, [tag | ancestor_tags], [])} | result
    ])
  end

  def do_melt_raw_html_into_ast([{tag, atts, ast, meta} | rest], ancestor_tags, result) do
    do_melt_raw_html_into_ast(rest, [tag | ancestor_tags], [
      {tag, atts, do_melt_raw_html_into_ast(ast, [tag | ancestor_tags], []), meta} | result
    ])
  end

  def do_melt_raw_html_into_ast([string | rest], [parent_tag | _] = ancestor_tags, result)
      when parent_tag in ["p", "P"] and is_binary(string) do
    do_melt_raw_html_into_ast(rest, ancestor_tags, [Floki.parse(string) | result])
  end

  def do_melt_raw_html_into_ast([string | rest], ancestor_tags, result) when is_binary(string) do
    do_melt_raw_html_into_ast(rest, ancestor_tags, [string | result])
  end
end

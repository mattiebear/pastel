defmodule PastelWeb.Date do
  def format_short(date) do
    Timex.format!(date, "{D} {Mshort} {YYYY}")
  end
end

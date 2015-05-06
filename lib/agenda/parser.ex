defmodule Agenda.Parser do
  def parse(schedule_string) do
    [minute, hour, day_of_month, month, day_of_week | command_bits] = String.split(schedule_string)
    command_string = Enum.join(command_bits)
    {:ok, command} = Code.string_to_quoted(command_string)
    parse(minute, hour, day_of_month, month, day_of_week, command)
  end
  def parse(minute, hour, day_of_month, month, day_of_week, command) do
    %Agenda.Schedule{minute: parse_pattern(minute, 0..59), hour: parse_pattern(hour, 0..23), day_of_month: parse_pattern(day_of_month, 1..31), month: parse_pattern(month, 1..12), day_of_week: parse_pattern(day_of_week, 0..6), command: command}
  end

  def parse_pattern("*/" <> modulo, range) do
    modulo = String.to_integer modulo
    Enum.filter(range, fn(i) ->
      rem(i, modulo) == 0
    end)
  end
  def parse_pattern("*", range) do
    Enum.to_list range
  end
  def parse_pattern(pattern, _range) do
    String.split(pattern, ",")
    |> Enum.map(fn(unit) -> String.to_integer(unit) end)
  end
end

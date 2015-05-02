defmodule Agenda.Schedule do
  defstruct [:minute, :hour, :day_of_month, :month, :day_of_week, :command]
end

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

defmodule AgendaTest do
  use ExUnit.Case

  @command Code.string_to_quoted!("Module.function(:arg1)")
  @command2 Code.string_to_quoted!("Module.function(:arg2, :arg3)")

  test "parsing a schedule string" do
    assert Agenda.Parser.parse("0 0 0 0 0 Module.function(:arg1)") == %Agenda.Schedule{minute: [0], hour: [0], day_of_month: [0], month: [0], day_of_week: [0], command: @command}
    assert Agenda.Parser.parse("1 0 0 0 0 Module.function(:arg2, :arg3)") == %Agenda.Schedule{minute: [1], hour: [0], day_of_month: [0], month: [0], day_of_week: [0], command: @command2}
  end

  test "parsing multiple hours in the pattern" do
    assert Agenda.Parser.parse("0 1,2 0 0 0 Module.function(:arg1)") == %Agenda.Schedule{minute: [0], hour: [1,2], day_of_month: [0], month: [0], day_of_week: [0], command: @command}
  end

  test "parsing a wildcard" do
    assert Agenda.Parser.parse("0 0 0 0 * Module.function(:arg1)") == %Agenda.Schedule{minute: [0], hour: [0], day_of_month: [0], month: [0], day_of_week: [0,1,2,3,4,5,6], command: @command}
  end

  test "parsing patterns like 'every five minutes'" do
    assert Agenda.Parser.parse("*/5 0 0 0 * Module.function(:arg1)") == %Agenda.Schedule{minute: [0,5,10,15,20,25,30,35,40,45,50,55], hour: [0], day_of_month: [0], month: [0], day_of_week: [0,1,2,3,4,5,6], command: @command}
  end
end

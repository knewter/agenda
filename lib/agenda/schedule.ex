defmodule Agenda.Schedule do
  defstruct [:minute, :hour, :day_of_month, :month, :day_of_week, :command]

  @type year  :: non_neg_integer
  @type month :: 1..12
  @type day   :: 1..31
  @type hour   :: 0..23
  @type minute :: 0..59
  @type second :: 0..59
  @type date :: {year, month, day}
  @type time :: {hour, minute, second}
  @type datetime :: {date, time}

  @spec include?(Agenda.Schedule, datetime) :: boolean
  def include?(schedule, {{year, month, day}=date, {hour, minute, _second}}) do
    [
      Enum.any?(schedule.minute, fn(min) -> min == minute end),
      Enum.any?(schedule.hour, fn(hr) -> hr == hour end),
      Enum.any?(schedule.day_of_week, fn(dow) -> :calendar.day_of_the_week(date) == dow end),
      Enum.any?(schedule.day_of_month, fn(dom) -> dom == day end),
      Enum.any?(schedule.month, fn(mon) -> mon == month end)
    ]
    |> Enum.all?
  end
end

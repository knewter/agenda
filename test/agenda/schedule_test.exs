defmodule Agenda.ScheduleTest do
  use ExUnit.Case
  alias Agenda.Schedule

  test "whether or not a schedule includes a given time" do
    good_times = [
      {{2015, 5, 5}, {23, 53, 42}}
    ]
    bad_times = [
      {{2015, 5, 5}, {22, 53, 42}},
      {{2015, 5, 5}, {23, 52, 42}}
    ]
    schedule = %Schedule{minute: [53], hour: [23], day_of_month: Enum.to_list(1..31), month: Enum.to_list(1..12), day_of_week: Enum.to_list(0..6)}
    parsed_schedule = Agenda.Parser.parse("53 23 * * * :ok")
    assert_schedule_time_spec_matches(schedule, good_times, bad_times)
    assert_schedule_time_spec_matches(parsed_schedule, good_times, bad_times)
  end

  test "matching day_of_week" do
    good_times = [
      {{2015, 5, 5}, {23, 53, 42}}
    ]
    bad_times = [
      {{2015, 5, 3}, {23, 53, 42}},
      {{2015, 5, 4}, {23, 53, 42}}
    ]
    schedule = %Schedule{minute: Enum.to_list(0..59), hour: Enum.to_list(0..23), day_of_month: Enum.to_list(1..31), month: Enum.to_list(1..12), day_of_week: [2]}
    parsed_schedule = Agenda.Parser.parse("* * * * 2 :ok")
    assert_schedule_time_spec_matches(schedule, good_times, bad_times)
    assert_schedule_time_spec_matches(parsed_schedule, good_times, bad_times)
  end

  test "matching day_of_month" do
    good_times = [
      {{2015, 5, 5}, {23, 53, 42}}
    ]
    bad_times = [
      {{2015, 5, 3}, {23, 53, 42}},
      {{2015, 5, 4}, {23, 53, 42}}
    ]
    schedule = %Schedule{minute: Enum.to_list(0..59), hour: Enum.to_list(0..23), day_of_month: [5], month: Enum.to_list(1..12), day_of_week: Enum.to_list(0..6)}
    parsed_schedule = Agenda.Parser.parse("* * 5 * * :ok")
    assert_schedule_time_spec_matches(schedule, good_times, bad_times)
    assert_schedule_time_spec_matches(parsed_schedule, good_times, bad_times)
  end

  test "matching month" do
    good_times = [
      {{2015, 5, 5}, {23, 53, 42}}
    ]
    bad_times = [
      {{2015, 6, 5}, {23, 53, 42}},
      {{2015, 3, 5}, {23, 53, 42}}
    ]
    schedule = %Schedule{minute: Enum.to_list(0..59), hour: Enum.to_list(0..23), day_of_month: Enum.to_list(1..31), month: [5], day_of_week: Enum.to_list(0..6)}
    parsed_schedule = Agenda.Parser.parse("* * * 5 * :ok")
    assert_schedule_time_spec_matches(schedule, good_times, bad_times)
    assert_schedule_time_spec_matches(parsed_schedule, good_times, bad_times)
  end

  def assert_schedule_time_spec_matches(schedule, good_times, bad_times) do
    Enum.each(good_times, fn(time) ->
      assert Schedule.include?(schedule, time)
    end)
    Enum.each(bad_times, fn(time) ->
      refute Schedule.include?(schedule, time)
    end)
  end
end

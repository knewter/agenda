defmodule AgendaTest do
  use ExUnit.Case

  @tag timeout: 80000
  @tag :slow
  test "adding commands as cron and having them executed" do
    pid_list = :erlang.pid_to_list(self)
    Agenda.add_schedule("* * * * * send(:erlang.list_to_pid(#{inspect pid_list}), :ok)")
    :timer.sleep(61000)
    assert_received(:ok)
  end

  @tag timeout: 80000
  @tag :slow
  test "adding commands as cron and then clearing all commands" do
    pid_list = :erlang.pid_to_list(self)
    Agenda.add_schedule("* * * * * send(:erlang.list_to_pid(#{inspect pid_list}), :ok)")
    :timer.sleep(30000)
    Agenda.clear_schedule
    :timer.sleep(31000)
    refute_received(:ok)
  end
end

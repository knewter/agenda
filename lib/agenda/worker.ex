defmodule Agenda.Worker do
  use GenServer
  @interval 60000

  ### Public API
  def start_link(:ok) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_schedule(schedule_string) do
    :ok = GenServer.cast(Agenda.Worker, {:add_schedule, schedule_string})
  end

  def clear_schedule do
    :ok = GenServer.cast(Agenda.Worker, :clear_schedule)
  end

  ### Server Callbacks
  def init(_) do
    :timer.send_interval(@interval, self, :tick)
    {:ok, []}
  end

  def handle_cast({:add_schedule, schedule_string}, schedules) do
    schedule = Agenda.Parser.parse(schedule_string)
    {:noreply, [schedule | schedules]}
  end
  def handle_cast(:clear_schedule, _schedules) do
    {:noreply, []}
  end

  def handle_info(:tick, schedules) do
    current_time = GoodTimes.now
    for schedule <- schedules do
      if Agenda.Schedule.include?(schedule, current_time) do
        Agenda.Schedule.execute_command(schedule)
      end
    end
    {:noreply, schedules}
  end
end

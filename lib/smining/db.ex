defmodule Smining.Db do
  use GenServer

  alias Smining.Rig

  def start_link(data_dir) do
    GenServer.start_link(__MODULE__, data_dir, name: __MODULE__)
  end

  def init(data_dir) do
    {:ok, db} = CubDB.start_link(data_dir)
    {:ok, db}
  end

  def handle_cast({:sync_rigs, rigs}, db) do
    IO.puts("Syncing #{length(rigs)} rigs...")
    CubDB.put(db, :rigs, rigs)
    IO.puts("Successfully synced #{length(rigs)} rigs!")
    {:noreply, db}
  end

  def handle_call(:get_rigs, _from, db) do
    {:reply, CubDB.get(db, :rigs), db}
  end

  def sync_rigs([%Rig{}] = rigs) do
    GenServer.cast(__MODULE__, {:sync_rigs, rigs})
  end

  def get_rigs() do
    GenServer.call(__MODULE__, :get_rigs)
  end
end

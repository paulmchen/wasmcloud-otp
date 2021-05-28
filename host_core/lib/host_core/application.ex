defmodule HostCore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false  

  use Application
  
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: HostCore.Worker.start_link(arg)
      # {HostCore.Worker, arg}
      {Registry, keys: :unique, name: EntityRegistry},      
      {HostCore.Host, strategy: :one_for_one, name: Host},
      {HostCore.Actors.PidMap, strategy: :one_for_one, name: HostCore.Actors.PidMap},
      {HostCore.Providers.ProviderSupervisor, strategy: :one_for_one, name: ProviderRoot},
      {HostCore.Actors.ActorSupervisor, strategy: :one_for_one, name: ActorRoot}      
    ]   

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HostCore.Supervisor]

    IO.puts "Starting Host Core"
    Supervisor.start_link(children, opts)
  end  

end
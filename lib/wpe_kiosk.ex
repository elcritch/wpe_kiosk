defmodule WpeKiosk do
  use GenServer

  require Logger

  def child_spec({opts, genserver_opts}) do
    id = genserver_opts[:id] || __MODULE__

    %{
      id: id,
      start: {__MODULE__, :start_link, [opts, genserver_opts]}
    }
  end

  def child_spec(opts) do
    child_spec({opts, []})
  end

  @moduledoc """
  Control a fullscreen WebKit browser using Elixir for use in a kiosk.

  Use `cog` from Igalia which is a WPE launcher and webapp container. See (Cog)[https://github.com/Igalia/cog].
  """

  @doc """
  Start the kiosk.

  The kiosk starts fullscreen and goes to a default local web page. To change
  this, set one or more options:

  * `homepage: url` - load this page first. For local files, specify `file:///path/to/index.html`
  * `use_touch: boolean` - uses touch inputs (e.g. mice)
  * `use_cursor: boolean` - uses cursor inputs (e.g. mice)
  * `init_udev_inputs`: boolean` - starts udev daemon to handle input device events
  * ...

  See `WpeKiosk.Options` for full list.

  Currently WIP, the full bindings for controlling the WPE "cog" program are undocumented.

  """
  @spec start_link(WpeKiosk.Options.t(), GenServer.options()) :: {:ok, pid} | {:error, term}
  def start_link(%WpeKiosk.Options{} = opts, genserver_opts \\ []) do
    GenServer.start_link(__MODULE__, opts, genserver_opts)
  end

  @doc """
  Stop the kiosk
  """
  @spec stop(GenServer.server()) :: :ok
  def stop(server) do
    GenServer.stop(server)
  end

  @impl true
  @spec init( WpeKiosk.Options.t()) :: {:ok, map() }
  def init(%WpeKiosk.Options{} = opts) do

    cmd =
      opts.cog_bin_path
      || System.find_executable("cog")
      || Path.join(:code.priv_dir(:wpe_kiosk), "usr/bin/cog")

    unless File.exists?(cmd) do
      Logger.error("Kiosk port application is missing at #{cmd}. Check that WPE is installed.")
      raise "Kiosk port missing"
    end

    envs = [ {'WPE_BCMRPI_TOUCH', opts.use_touch},
              {'WPE_BCMRPI_CURSOR', opts.use_cursor} ]

    args = [ opts.homepage ]

    GenServer.cast(self(), :start)
    {:ok, %{ cmd: cmd, args: args, envs: envs, port: nil, opts: opts }}
  end

  @impl true
  def handle_cast(:start, state) do
    # Optional Pause -- starting the browser can hit the system hard and it's helpful to wait a bit
    Process.sleep(state.opts.startup_delay_ms)

    if state.opts.init_udev_inputs do
      platform_init_events(state.opts.udev_init_delay_ms)
    end

    Logger.info("Starting WPE Cog")
    port =
      Port.open({:spawn_executable, state.cmd}, [
        {:args, state.args},
        {:env, state.envs},
        :use_stdio,
        :binary,
        :exit_status
      ])

    unless port |> Port.info() do
      Logger.error("Kiosk port not starting correctly. ")
      raise "Kiosk Port error"
    end

    {:noreply, %{ state | port: port}}
  end

  @doc """
  Force exit of Cog, despite starting as a port, Cog doesn't seem to die properly. FIXME?
  """
  @impl true
  def terminate(reason, state) do
    Logger.error "#{__MODULE__}.terminate/2 called with reason: #{inspect reason}"
    port_info = Port.info(state.port)
    Logger.error("#{__MODULE__}.termindate port: #{inspect port_info}")

    case port_info[:os_pid] do
      ospid when is_number(ospid) ->
        Logger.info "#{__MODULE__} terminate port, os process: #{inspect ospid}"
        System.cmd("kill", ["-KILL", "#{ospid}"], [])
      nil ->
        nil
    end
  end

  def platform_init_events(udev_init_delay_ms) do
    # Initialize eudev
    Logger.info("Starting udev event handlers")
    :os.cmd('udevd -d');
    :os.cmd('udevadm trigger --type=subsystems --action=add');
    :os.cmd('udevadm trigger --type=devices --action=add');
    :os.cmd('udevadm settle --timeout=30');
    Process.sleep(udev_init_delay_ms)
  end

end

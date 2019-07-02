defmodule WebengineKiosk.Options do
  alias __MODULE__

  @type t :: %Options{
    homepage: String.t(),
    cog_bin_path: nil | binary(),
    use_touch: boolean(),
    use_cursor: boolean(),
    init_udev_inputs: boolean(),
    startup_delay_ms: pos_integer(),
    udev_init_delay_ms: pos_integer(),
  }

  @doc """
  Kiosk Options

  * `homepage: url` - load this page first. For local files, specify `file:///path/to/index.html`
  * `use_touch: boolean` - uses touch inputs (e.g. mice)
  * `use_cursor: boolean` - uses cursor inputs (e.g. mice)
  * `init_udev_inputs`: boolean` - starts udev daemon to handle input device events

  """
  defstruct homepage: "127.0.0.1/",
            cog_bin_path: nil,
            init_udev_inputs: true,
            use_cursor: false,
            use_touch: true,
            startup_delay_ms: 0,
            udev_init_delay_ms: 0

end

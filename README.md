# WpeKiosk

Simple wrapper around [Cog](https://github.com/Igalia/cog) which is a [WPE](https://webkit.org/wpe/) launcher and webapp container. Runs a fullscreen kiosk-style brwoser with hardware GPU acceleration and multimedia extensions. WebGL works. 

```elixir
opts = %WpeKiosk.Options{
  cog_bin_path: nil,
  homepage: "https://akirodic.com/p/jellyfish/",
  init_udev_inputs: true,
  startup_delay_ms: 0,
  udev_init_delay_ms: 0,
  use_cursor: false,
  use_touch: true
}

pid = WpeKiosk.start_link(opts) 
```
## Limitatioins 

Currently only the bare minimum configuration for Cog is supported. This means the browser can _only_ be run fullscreen. 

For example, to browse to a new url you need to stop WpeKiosk pid, and then restart it with a new homepage. For kiosks this shouldn't bee an issue. 

## Installation

```elixir
def deps do
  [
    {:wpe_kiosk, "~> 0.1.0"}
  ]
end
```

Important! Must use a base image that provides WPE with Cog. A customized Nerves image [wpe_kiosk_rpi3](https://github.com/elcritch/wpe_kiosk_rpi3/) is avialble for the RPi3 which provides cog and can run with out-of-the-box with the official RPi touchscreens. 

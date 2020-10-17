# localcaddy

LaunchAgent and bash executable for running caddy locally on macOS.

These files make a few assumptions upfront, customize to your needs:

1. That you have downloaded [caddy](https://caddyserver.com/) and installed it at the path `/usr/local/bin/caddy`.
2. That you have a [Caddyfile](https://caddyserver.com/docs/caddyfile-tutorial) already available to use.

**Setup**

1. Clone or download this repository.
2. Configure the LaunchAgent and script to your needs.
   1. In `caddyctl`:
      1. On line 3, set `CONFIG_PATH` to the path of your `Caddyfile`.
   2. In `com.caddy.server.plist`:
      1. On line 13 and 16, set your preferred paths for logs.
      2. On line 26, set the path to your Caddyfile (same as `CONFIG_PATH`).
3. Verify `caddyctl` is user-executable and move to `/usr/local/bin` or anywhere else in your `$PATH`.
4. Move `com.caddy.server.plist` to `~/Library/LaunchAgents`.

**Running**

In a new terminal window, run `caddyctl start` to load and start Caddy. Caddy will stay running and load automatically when your computer restarts.

Other commands:
`caddyctl stop` - Stops Caddy and unloads the LaunchAgent.
`caddyctl reload` - Runs `caddy reload` using the config path you set.
`caddyctl restart` - Stops Caddy, unloads the LaunchAgent, reloads the LaunchAgent and then starts Caddy.

# localcaddy

An opinionated LaunchAgent and bash executable for running caddy locally on macOS.

These files make a few assumptions upfront, customize to your needs:

1. You have downloaded [caddy](https://caddyserver.com/) and installed it in your `$PATH`.
2. You have sudo privileges, if on macOS 10.14 Mojave or later you can bind to ports >1024 without needing to be root.

## Setup

1. Clone or download a ZIP of this repository and unzip it
2. From here you can extract the files from dist/ and modify them to your needs, or execute `./scripts/setup.sh` from a terminal session to automate setup. Instructions for both are below.

**Automatic Setup**

1. The automatic setup script will take actions in 2 steps, first involving adding the recommended files and folders, second is adding the job file to ~/LaunchAgents and granting root permissions to Caddy just in case port 80 or 443 can't be bound to.
2. Enter the **absolute** path to your local development directory when prompted. While it is possible to enter a relative path whatever input is given will be copied directly to the configuration files and be relative to the placements of the created files. If no path is entered, the script will default to `~/Developer/www`. The script will then add `/config`, `/log`, and `/public` to the specified path.
3. If a `Caddyfile` is already present in `config/Caddyfile` in the path you specified, one will not be set up for you. If there is no `Caddyfile` present the script will modify the one present in `dist/Caddyfile` and copy it to the path you specified.
4. When prompted, you can choose whether you'd like to install the `launchd` job files and `caddyctl` which will assist in managing the job. If yes, `root` will take ownership of `caddy` in order to guarantee privileged ports can be opened. A LaunchAgent will then be added to ~/Library/LaunchAgents. Lastly, `caddyctl` will be given executable permissions and copied to `/usr/local/bin`.

**Manual Setup**

Edit the files in `dist/` to fit your needs:

`caddyctl` - A executable inspired by Apple/Apache's `apachectl` for macOS. Makes managing the launchd job in `com.caddyserver.plist` easier. Replace `<ROOT_PATH>` with your working directory.

`Caddyfile` - Configuration file for Caddy. Replace `<ROOT_PATH>` with your working directory.

`com.caddyserver.plist` - Configuration file for `launchd`. Ensure that `<key>WorkingDirectory</key>` and `<key>ProgramArguments</key>` are correct for your working directory and start command, respectively.

## Running

In a new terminal window, run `caddyctl start` to load the installed LaunchAgent and start Caddy. Caddy will stay running and load automatically when your computer restarts.

Other commands:
`caddyctl stop` - Stops Caddy and unloads the LaunchAgent.
`caddyctl reload` - Runs `caddy reload` using the config path you set.
`caddyctl restart` - Stops Caddy, unloads the LaunchAgent, loads the LaunchAgent and then starts Caddy.
`caddyctl configtest <path>` - Tests a configuration give in the `<path>` argument.

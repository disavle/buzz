# Short commands for working on Buzz from the terminal.
#
# Add one line to ~/.zshrc (use the path where you cloned the repo):
#     source ~/Developer/buzz/scripts/buzz.zsh
# Then open a new terminal tab or run `exec zsh`.
#
# Every command works from any folder: it finds the repo by the location of this file.

# Path to the repo root. ${(%):-%x} is the path of the file being sourced,
# :A makes it absolute, :h:h goes two folders up (scripts/ -> repo root).
export BUZZ_HOME="${${(%):-%x}:A:h:h}"

alias buzz='cd "$BUZZ_HOME"'                            # go to the repo
alias buzz-gen='mise -C "$BUZZ_HOME" run generate'      # after clone or git pull
alias buzz-open='mise -C "$BUZZ_HOME" run open'         # open the workspace in Xcode
alias buzz-ios='mise -C "$BUZZ_HOME" run ios'           # build and run the app in the simulator
alias buzz-api='mise -C "$BUZZ_HOME" run backend:run'   # Vapor server in this tab, Ctrl+C to stop
alias buzz-test='mise -C "$BUZZ_HOME" run test && mise -C "$BUZZ_HOME" run backend:test'
alias buzz-lint='mise -C "$BUZZ_HOME" run lint'

# Server in the background + app in the simulator, in one command.
# The server log goes to Backend/server.log; stop the server with `buzz-stop`.
buzz-dev() {
  local log="$BUZZ_HOME/Backend/server.log"
  mise -C "$BUZZ_HOME" run backend:run >"$log" 2>&1 &
  echo $! >"$BUZZ_HOME/Backend/.server.pid"
  echo "Backend started (pid $!), log: $log"
  mise -C "$BUZZ_HOME" run ios
}

buzz-stop() {
  local pidfile="$BUZZ_HOME/Backend/.server.pid"
  if [[ -f "$pidfile" ]]; then
    # kill the whole process group: mise starts `swift run`, which starts the server
    kill -- -"$(ps -o pgid= -p "$(cat "$pidfile")" | tr -d ' ')" 2>/dev/null || kill "$(cat "$pidfile")" 2>/dev/null
    rm -f "$pidfile"
    echo "Backend stopped"
  else
    echo "Backend is not running (no $pidfile)"
  fi
}

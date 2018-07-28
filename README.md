# cccd-rust-playground
Fumbling with Rust to see how to integrate it with conda, cross-compilation and docker (macOS)

# To use VSCode as an IDE, on macOS you need to set some env. vars that GUI programs will see:
# 1. Add these lines to /etc/launchd.conf
setenv RUSTUP_HOME /opt/rust/.cargo.Darwin/rustup
setenv CARGO_HOME /opt/rust/.cargo.Darwin
setenv CARGO_CONFIG /opt/rust/.cargo.Darwin/config
# and invoke them for this shell:
grep -E "^setenv" /etc/launchd.conf | xargs -t -L 1 launchctl

# .. or maybe add this to ~/Library/LaunchAgents/environment.plist
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>my.startup</string>
  <key>ProgramArguments</key>
  <array>
    <string>sh</string>
    <string>-c</string>
    <string>
      launchctl setenv FOO foo
      launchctl setenv BAR bar
      launchctl setenv RUSTUP_HOME /opt/rust/.cargo.Darwin/rustup
      launchctl setenv CARGO_HOME /opt/rust/.cargo.Darwin
      launchctl setenv CARGO_CONFIG /opt/rust/.cargo.Darwin/config
    </string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
```

# and run:

```
launchctl load ~/Library/LaunchAgents/environment.plist
```

# 2. Launch VSCode and install all the plugins (check in the VSCode terminal that the env vars above are set).
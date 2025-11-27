export ANDROID_HOME=$HOME/.android_sdk
if test -d "$ANDROID_HOME"
  fish_add_path $ANDROID_HOME/emulator/
  fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin/
  fish_add_path $ANDROID_HOME/platform-tools
end

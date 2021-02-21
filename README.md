This is a Among Us private server selector for Steam on Linux. It automagically allows for server selection while starting Among Us. If you also want to use it, follow these steps:

# 0. Necessary dependencies:
- gnome-terminal (would probably also work with other terminal emulators if code for them is added – Pull requests are welcome!)
- dig

# 1. Clone
Clone the repository. Enter a terminal and type:

```bash
$ git clone https://github.com/bartim/Impostux.git
$ cd Impostux
```

# 2. Configure
You can edit some configuration options in the beginning of set_impostor.sh:
- **REGION_INFO_FILE**: Path to the regionInfo.dat file. Do not change unless you know what you do.
- **DEFAULT_SERVER**: Default server, or `skip` to not switch the server by default.
- **DEFAULT_PORT**: Default port.
- **PROMPT_SERVER**: Either `y` (for yes) or `n` (for no). If `y`, the script asks which server and port it should use (and uses the defaults if nothing is entered). If `n`, the script always uses defaults without asking.
- **CONFIRM_SERVER**: Either `y` (for yes) or `n` (for no). If `y`, the script shows you which server will now be used before starting the game. Otherwise, the game will be started without confirmation.

# 3. Install executables
Enter a terminal and type:

```bash
$ mkdir ~/.local/bin/
$ cp impostor_wrapper.sh set_impostor.sh ~/.local/bin/
```

# 4. Add to launch options
Add  `~/.local/bin/impostor_wrapper.sh` to the launch options for Among Us in Steam:
1. Open Steam
2. Go to *Library*
3. Right click *Among Us*
4. Click *Properties*
5. Insert `~/.local/bin/impostor_wrapper.sh` in front of `%command%`

# Change configuration options again
If you want to change the configuration options after you have already installed the executables (see step 3), you can edit the file located in `~/.local/bin/set_impostor.sh`. See step 2 for configuration options.

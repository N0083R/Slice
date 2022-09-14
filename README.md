## Install The `slice` Binary (No Build)

To install the `slice` binary file, just clone this repository into your `home` folder using the git command:
```bash
git clone https://github.com/N0083R/Slice.git ~/Slice && cd ~/Slice && cd ./bin
```
Then, **copy** the `slice` binary to a location of your choice. The default permissions for the binary is `755`.
<hr>

## Build `slice` From Source
To build `slice` from source, execute the commands below in your terminal:
```bash
git clone https://github.com/N0083R/Slice.git ~/Slice && cd ~/Slice
bash ./build.sh
```
1. The `build.sh` file will ask to install the necessary files (if they are not already installed).
2. When the build is complete, it will move the `slice` binary into `$HOME/.local/bin` (if the directory exists).
3. After the file is moved, its file permissions are changed to *4751* (-rwsr-x--x) [sets the **setuid** bit].
4. Finally, if there's no **alternative link** [`update-alternatives`] then will be created in `/usr/bin`.

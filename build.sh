#!/usr/bin/env bash

os=
chromeos=0;
isdebian=0;
hasnim=0;
hasmusl=0;
nimc=

setup() {

    # check if OS is not Linux and exit if OS is not supported
    if [ "$(uname -s)" = Linux ] || [ "$(uname -o)" = "GNU/Linux" ]; then
        os='Linux'
    fi

    # check if OS is ChromeOS
    if [ "$(uname -n)" = penguin ]; then
        chromeos=1;
    fi

    # check CPU architecture
    if [ "$(uname -m)" != "x86_64" ]; then
        echo -e "\nCPU archtecture must be 'x86_64'\n";
        exit 1;
    fi

    # check if the OS is Linux and/or if it's Linux on ChromeOS and whether apt is present which
    # denotes OS is Debian based 
    if [ "$os" = Linux ] || [[ $chromeos -eq 1 ]] && [ -f "/usr/bin/apt" ]; then
        isdebian=1;
    fi

    # check if nim is installed, otherwise ask to install nim and cancel install if not
    if [ -d "$HOME/.nimble" ] && [ -f "$HOME/.nimble/bin/nim" ]; then
        hasnim=1
    
    else
        echo -en "\033[01;32mnim\033[00m isn't installed. Do you want to install it? (Y/N): "; read -r choice

        if [ "$choice" = y ] || [ "$choice" = Y ]; then
            if [ -f "/usr/bin/curl" ]; then
                curl https://nim-lang.org/choosenim/init.sh -sSf | sh
                echo -e '\n\n# path to nim export\nPATH=$PATH:$HOME/.nimble/bin' >> "$HOME/.bashrc"
                hasnim=1;

            else
                if [[ $isdebian -eq 1 ]] && [ ! -f "/usr/bin/curl" ]; then
                        sudo apt-get -y install curl
                else
                    echo -e "sudo priviledges are needed to install curl";
                    exit 1;
                fi
                
                curl https://nim-lang.org/choosenim/init.sh -sSf | sh
                echo -e '\n\n# path to nim export\nPATH=$PATH:$HOME/.nimble/bin' >> "$HOME/.bashrc"
                hasnim=1;
            fi

        elif [ "$choice" = n ] || [ "$choice" = N ]; then
            echo -e "\033[01;31mBuild Failed\033[00m!";
            exit 1;
        fi
    fi

    # check if musl is installed. If not then install it if the user chose to install nim
    if [ ! -d "/usr/local/musl" ] && [ ! -f "/usr/local/musl/bin/musl-gcc" ] && [ ! -f "/usr/bin/musl-gcc" ] && [ -f "$PWD/deps/musl-1.2.3.tar.gz" ]; then
        sudo apt-get -y install build-essential &&\
            tar -xzvf "$PWD/deps/musl-1.2.3.tar.gz" && cd "$PWD/musl-1.2.3" && ./configure --prefix=/usr/local/musl && make -j4 && sudo make install &&\
            cd ..
        sudo rm --interactive=never -r "$PWD/musl-1.2.3/"
        echo -e '\n\n# musl-gcc path\nPATH=$PATH:/usr/local/musl/bin' >> "$HOME/.bashrc"
        hasmusl=1;

    else
        hasmusl=1;
    fi
}

setup
source "$HOME/.bashrc"
sleep 1.5

__build_slice() {
    # check for valid .nim files in the current directory and build them using nim, then install the
    # binary to the proper location after changing its permissions
    if [[ $hasmusl -eq 1 ]] && [[ $hasnim -eq 1 ]]; then
        compargs='--gcc.exe:musl-gcc --gcc.linkerexe:musl-gcc --passL:-static --passL:-s'
        nimargs='-d:release --threads:on --opt:size --os:linux --out:slice compile'
        nimc="nim ${compargs} ${nimargs}"
        
        cd "$PWD/src" && command $nimc "$PWD/Main.nim" && upx --best "$PWD/slice" &> /dev/null
        
        echo -e "\n\033[01;32mChanging Owner\033[00m to \033[01;31mroot\033[00m";
        sudo chown root "$PWD/slice" 
        sleep 1;
        
        echo -e "\n\033[01;32mChanging Group\033[00m to \033[01;31mroot\033[00m";
        sudo chgrp root "$PWD/slice"
        sleep 1;
       
        echo -e "\n\033[01;32mChanging Mode\033[00m to \033[01;32m4751\033[00m (-rws-r-x--x)";
        sudo chmod 4751 "$PWD/slice"
        sleep 1;

        echo -e "\n\033[01;32mMoving File\033[00m to \033[01;34m$HOME/.local.bin\033[00m";
        sudo mv "$PWD/slice" "$HOME/.local/bin/" 
        sleep 1;
        
        echo -e "\n\033[01;32mCreating Symlink\033[00m to \033[01;34m$HOME/.local/bin/slice\033[00m in \033[01;34m/usr/bin\033[00m";
        sudo update-alternatives --install "/usr/bin/slice" slice "$HOME/.local/bin/slice" 1
        sleep 1;

        echo -e "\n\033[01;32mInstall Complete\033[00m!";
        sleep 1;

        echo -e "Use '\033[01;35mslice -h\033[00m' or '\033[01;35mslice --help\033[00m' for usage information";
        exit 0;
    
    else
        echo -e "\nCan't locate source files";
        exit 1;
    fi
}

__build_slice

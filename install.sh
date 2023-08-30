#!/bin/bash

# moves ~/.local/share/nvim to current dir and deletes it
remove_current_nvim_config() {
    mv ~/.config/nvim .backup/nvim.bak
    mv ~/.local/share/nvim .backup/share/nvim.bak
}

# install nvim templete
install_nvim_config() {
    cp -r ./config/nvim ~/.config/nvim
    cp -r ./.local/share/nvim ~/.local/share/nvim
}

ensure_ripgrep() {
    REQUIRED_PKG="ripgrep"
    if [ "$(dpkg-query -W -f='${Status}' "$REQUIRED_PKG" 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
        echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
        curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb"
        sudo dpkg -i ripgrep_13.0.0_amd64.deb
        rm ripgrep_13.0.0_amd64.deb

    fi

}

ensure_packeges() {
    sudo apt-get update
    sudo apt-get install --install build-essential -y

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    sudo apt update
    nvm install

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs >rustup.sh
    chmod +x ./rustup.sh
    ./rustup.sh -y -q
    rm ./rustup.sh
    source "$HOME/.cargo/env"

    cd "$HOME"
    curl -LO https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
    tar -x -f go1.21.0.linux-amd64.tar.gz
    sudo ln -s ~/go/bin/go /usr/local/bin/go
    sudo ln -s ~/go/bin/gofmt /usr/local/bin/gofmt
    rm go1.21.0.linux-amd64.tar.gz
}

ensure_nvim() {
    REQUIRED_PKG="nvim"
    if [ "$(dpkg-query -W -f='${Status}' "$REQUIRED_PKG" 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
        echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
        curl -LO "https://github.com/neovim/neovim/releases/download/v0.9.1/nvim-linux64.tar.gz"
        tar -x -f nvim-linux64.tar.gz
        sudo mv nvim-linux64 /usr/local/bin
        sudo ln -s /usr/local/bin/nvim-linux64/bin/nvim /usr/local/bin/nvim
        rm nvim-linux64.tar.gz

    fi
}

# ensure dependences
ensure_dep() {
    ensure_packeges
    ensure_nvim
    ensure_ripgrep
}

main() {
    ensure_dep

    remove_current_nvim_config

    install_nvim_config

    nvim
}

main

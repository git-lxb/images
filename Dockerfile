FROM ubuntu:24.04
LABEL Name=base Version=0.1.0

ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive

# gdu - Pretty fast disk usage analyzer written in Go.
# nnn - (n³) is a full-featured terminal file manager. It's tiny, nearly 0-config and incredibly fast.

RUN set -ex && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 
RUN yes | unminimize && \
    apt update -qq && apt install -y -qq bsdmainutils build-essential btop cmatrix curl fd-find gdu git hyperfine jq language-pack-zh-hans locales man manpages manpages-zh manpages-dev nnn nodejs npm python3 python3-pip python3-venv ripgrep sl sudo tmux tree tzdata unzip wget wrk xclip zsh && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    ln -s $(which python3) /usr/local/bin/python && \
    ln -s $(which node) /usr/local/bin/node && \
    # locale
    locale-gen zh_CN.UTF-8 

# Set the locale environment variables
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

# Update default locale settings
RUN update-locale LANG=zh_CN.UTF-8 && \
    # sl
    ln -sf /usr/games/sl /usr/local/bin/sl && \
    # fd
    ln -s $(which fdfind) /usr/local/bin/fd && \

    GITHUB_REPO="https://api.github.com/repos" && \

    # bat - A cat(0) clone with syntax highlighting and Git integration.
    BAT_VERSION=$(curl -s "${GITHUB_REPO}/sharkdp/bat/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -sLo bat.deb https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-musl_${BAT_VERSION}_amd64.deb && \
    dpkg -i bat.deb && rm -rf bat.deb && \

    # bottom - A customizable cross-platform graphical process/system monitor for the terminal.
    BOTTOM_VERSION=$(curl -s "${GITHUB_REPO}/ClementTsang/bottom/releases/latest" | grep -Po '(?<="tag_name": ")[^"]+') && \
    curl -sLo bottom.deb https://github.com/ClementTsang/bottom/releases/download/${BOTTOM_VERSION}/bottom_${BOTTOM_VERSION}-1_amd64.deb && \
    dpkg -i bottom.deb && rm -rf bottom.deb && \

    # eza - A modern, maintained replacement for ls
    EZA_VERSION=$(curl -s "${GITHUB_REPO}/eza-community/eza/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -sLo eza_x86_64-unknown-linux-gnu.tar.gz https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_x86_64-unknown-linux-gnu.tar.gz && \
    tar xf eza_x86_64-unknown-linux-gnu.tar.gz && install eza /usr/local/bin && rm -rf eza* && \

    # gitui - Blazing 💥 fast terminal-ui for git written in rust 🦀
    GITUI_VERSION=$(curl -s "${GITHUB_REPO}/extrawurst/gitui/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -sLo gitui.tar.gz https://github.com/extrawurst/gitui/releases/download/v${GITUI_VERSION}/gitui-linux-x86_64.tar.gz && \
    tar xf gitui.tar.gz && install gitui /usr/local/bin && rm -rf gitui.tar.gz gitui && \

    # glow - Render markdown on the CLI, with pizzazz!
    GLOW_VERSION=$(curl -s "${GITHUB_REPO}/charmbracelet/glow/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -sLo glow.deb https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_amd64.deb && \
    dpkg -i glow.deb && rm -rf glow.deb && \

    # lazygit - A simple terminal UI for git commands
    LAZYGIT_VERSION=$(curl -s "${GITHUB_REPO}/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && install lazygit /usr/local/bin && rm -rf lazy* && \

    # lsd - This project is a rewrite of GNU ls with lots of added features like colors, icons, tree-view, more formatting options etc. 
    LSD_VERSION=$(curl -s "${GITHUB_REPO}/lsd-rs/lsd/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -sLo lsd.deb https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/lsd-musl_${LSD_VERSION}_amd64.deb && \
    dpkg -i lsd.deb && rm -rf lsd.deb && \

    # miniserve - 🌟 For when you really just want to serve some files over HTTP right now!
    MINISERVE_VERSION=$(curl -s "${GITHUB_REPO}/svenstaro/miniserve/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -sLo miniserve https://github.com/svenstaro/miniserve/releases/download/v${MINISERVE_VERSION}/miniserve-${MINISERVE_VERSION}-x86_64-unknown-linux-gnu && \
    mv miniserve /usr/local/bin && \

    # typst - A new markup-based typesetting system that is powerful and easy to learn.
    TYPST_VERSION=$(curl -s "${GITHUB_REPO}/typst/typst/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -sLo typst.tar.xz https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz && \
    tar xf typst.tar.xz -C /usr/local/share && ln -sf /usr/local/share/typst-x86_64-unknown-linux-musl/typst /usr/local/bin/typst && rm typst.tar.xz && \

    # yazi - 💥 Blazing fast terminal file manager written in Rust, based on async I/O.
    YAZI_VERSION=$(curl -s "${GITHUB_REPO}/sxyazi/yazi/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -sLo yazi.zip https://github.com/sxyazi/yazi/releases/download/v${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.zip && \
    unzip yazi.zip && rm yazi.zip && mv yazi-x86_64-unknown-linux-gnu /usr/local/share && \
    ln -sf /usr/local/share/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/yazi && \
    ln -sf /usr/local/share/yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/ya && \

    # neovim - Vim-fork focused on extensibility and usability
    NVIM_VERSION=$(curl -s "${GITHUB_REPO}/neovim/neovim/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -sLo neovim.tar.gz https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux64.tar.gz && \
    tar xf neovim.tar.gz -C /usr/local/share/ && rm neovim.tar.gz && ln -sf /usr/local/share/nvim-linux64/bin/nvim /usr/local/bin/nvim && \

    # add user zw
    groupadd zw && useradd -m -g zw zw && usermod -aG sudo zw && echo "zw ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER zw:zw
WORKDIR /home/zw
    
    # zsh
RUN CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    # zsh plugins
    git clone -q https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions && \
    echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZSOTDIR:-$HOME}/.zshrc && \
    git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting && \
    echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc && \
    git clone -q https://github.com/zsh-users/zsh-completions ~/.zsh/zsh-completions && \
    echo "source ~/.zsh/zsh-completions/zsh-completions.plugin.zsh" >> ${ZSOTDIR:-$HOME}/.zshrc && \
    
    # Python
    mkdir -p ~/.config/pip/ && \
    echo '[global]' > ~/.config/pip/pip.conf && \
    echo '    break-system-packages = true' >> ~/.config/pip/pip.conf && \
    pip3 install --no-cache-dir pynvim numpy pandas matplotlib ruff && echo 'export PATH=$PATH:/home/zw/.local/bin' >>~/.zshrc && \
    
    # starship - ☄🌌️ The minimal, blazing-fast, and infinitely customizable prompt for any shell!
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y && \
	echo 'eval "$(starship init zsh)"' >>~/.zshrc && \
	mkdir -p ~/.config && \
	starship preset pastel-powerline -o ~/.config/starship.toml
 
RUN git clone -q --depth 1 https://github.com/AstroNvim/template ~/.config/nvim 

COPY nvimconf/init.lua /home/zw/.config/nvim/init.lua
COPY nvimconf/community.lua /home/zw/.config/nvim/lua/community.lua
COPY nvimconf/user.lua /home/zw/.config/nvim/lua/plugins/user.lua

    # nvim --headless +"Lazy! sync" +qall > /dev/null 2>&1 && \
RUN nvim --headless +"Lazy! sync" +qall
    # nvim --headless +"MasonInstall bash-language-server clangd dockerfile-language-server html-lsp json-lsp lua-language-server markdownlint python-lsp-server tailwindcss-language-server typescript-language-server typst-lsp vuels yamlls" +qall && \

CMD [ "/bin/zsh" ]

{
  pkgs,
  unstable,
  config,
  meg,
  ...
}:

let
  hyprlayout = pkgs.callPackage ./hyprlayout.nix { };
  lz4json = pkgs.callPackage ./lz4json.nix { };
  tmux-sessionizer = pkgs.callPackage ./tmux-sessionizer.nix { };
in
{
  nixpkgs.config.allowUnfree = true;

  programs = {
    alacritty = {
      enable = true;
      settings = {
        window = {
          dimensions = {
            lines = 40;
            columns = 80;
          };
          opacity = 0.9;
          padding = {
            x = 1;
            y = 1;
          };
          dynamic_padding = true;
          decorations = "full";
          dynamic_title = true;
        };
        scrolling = {
          history = 10000;
          multiplier = 5;
        };
        font = {
          size = 12;
        };
        keyboard.bindings = [
          {
            key = "Return";
            mods = "Control|Shift";
            action = "SpawnNewInstance";
          }
        ];
      };
    };

    kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font";
        size = 10;
      };
      theme = "Tokyo Night";
      settings = {
        background_opacity = "0.9";
        editor = "vi";
        enabled_layouts = "tall,fat,grid,stack";
      };
      shellIntegration = {
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
      keybindings = {
        "alt+s" = "toggle_layout stack";
        "alt+shift+s" = "goto_layout stack";
        "alt+shift+g" = "goto_layout grid";
        "alt+shift+v" = "goto_layout tall";
        "alt+shift+c" = "goto_layout fat";
        "alt+t" = "select_tab";
        "alt+shift+t" = "new_tab_with_cwd";
        "alt+n" = "next_tab";
        "alt+p" = "previous_tab";
        "alt+h" = "neighboring_window left";
        "alt+l" = "neighboring_window right";
        "alt+k" = "neighboring_window top";
        "alt+j" = "neighboring_window bottom";
        # "alt+w" = "focus_visible_window";
        "ctrl+shift+enter" = "new_window_with_cwd";
        "ctrl+shift+n" = "new_os_window_with_cwd";
      };
    };

    git = {
      enable = true;
      userName = "Pavel Stepanov";
      userEmail = "paulkreuzmann@gmail.com";
      extraConfig = {
        core.compression = 9;
        http.followRedirects = "true";
        http.maxRequests = 5;
        protocol.version = 2;
        init.defaultBranch = "main";
      };
    };

    emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
      extraPackages = (epkgs: with epkgs; [ vterm ]);
    };

    neovim = {
      enable = true;
      package = unstable.neovim-unwrapped;
      viAlias = true;
      vimAlias = true;
      extraPackages = with unstable; [
        gcc
        luajitPackages.luarocks
      ];
    };

    waybar.enable = true;

    zsh = {
      enable = true;
      autocd = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "viins";
      #shellAliases = aliases;
      initExtraBeforeCompInit = ''
        fpath=(~/.config/zsh/completion $fpath)
      '';
      # Plugins
      plugins = [
        # sfz-prompt
        {
          name = "sfz";
          src = builtins.fetchGit {
            url = "https://github.com/teu5us/sfz-prompt.zsh";
            rev = "1419b468675c367fa44cd14e1bf86997f2ada5fc";
          };
        }
        {
          name = "fzf-tab";
          src = builtins.fetchGit {
            url = "https://github.com/Aloxaf/fzf-tab";
            rev = "c5c6e1d82910fb24072a10855c03e31ea2c51563";
          };
        }
      ];
      initExtra = ''
        # Emacs tramp fix
        if [[ "$TERM" == "dumb" ]]
        then
          unsetopt zle
          unsetopt prompt_cr
          unsetopt prompt_subst
          # unfunction precmd
          # unfunction preexec
          export PS1='$ '
        fi

        bindkey -s ^e "tmux-sessionizer\n"
        bindkey '^F' autosuggest-accept
        bindkey '^G' toggle-fzf-tab

        # indicate mode by cursor shape
        zle-keymap-select () {
        if [ $KEYMAP = vicmd ]; then
            printf "\033[2 q"
        else
            printf "\033[6 q"
        fi
                        }
        zle-line-init () {
            zle -K viins
            printf "\033[6 q"
                        }
        zle-line-finish () {
            printf "\033[2 q"
                        }
        zle -N zle-keymap-select
        zle -N zle-line-init
        zle -N zle-line-finish

        DISABLE_AUTO_TITLE="true"

        function precmd() {
          # echo -en "\e]2;$@\a"
          print -Pn "\e]0;%~\a"
        }
      '';
    };

    autojump.enable = true;

    fzf = {
      enable = true;
      defaultCommand = "fd --type f";
      defaultOptions = [
        "--height 40%"
        "--prompt »"
        "--layout=reverse"
      ];
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [ "--preview 'head {}'" ];
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
      # historyWidgetCommand = "history";
      # historyWidgetOptions = [ ];
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };

  services = {
    emacs = {
      package = config.programs.emacs.finalPackage;
      enable = true;
      defaultEditor = true;
      socketActivation.enable = true;
      startWithUserSession = false;
    };

    hyprpaper = {
      enable = true;
      settings = {
        preload = [ "~/.config/wallpaperflare.com_wallpaper.jpg" ];
        wallpaper = [
          "eDP-1,~/.config/wallpaperflare.com_wallpaper.jpg"
          "HDMI-A-1,~/.config/wallpaperflare.com_wallpaper.jpg"
        ];
      };
    };

    blueman-applet.enable = true;

    udiskie = {
      enable = true;
      tray = "auto";
      automount = false;
      notify = true;
    };

    network-manager-applet.enable = true;

    syncthing = {
      enable = true;
      tray.enable = true;
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.tokyonight-gtk-theme;
      name = "Tokyonight-Dark-BL-LB";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      source = ~/.config/hypr/dynamic.conf
    '';
  };

  home = {
    username = "suess";
    homeDirectory = "/home/suess";

    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
      x11.defaultCursor = "left_ptr";
    };

    packages = with pkgs; [
      appimage-run
      black
      chromium
      cliphist
      discord
      docker-compose-language-service
      dockerfile-language-server-nodejs
      emmet-ls
      exercism
      gnome.nautilus
      gnome.sushi
      gopls
      graphviz
      hyprlayout
      hyprshot
      imagemagickBig
      insomnia
      jq
      lz4json
      marksman
      meg.packages.x86_64-linux.meg
      mongodb-compass
      nixd
      nixfmt-rfc-style
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      obs-studio
      obsidian
      onlyoffice-bin
      pandoc
      pavucontrol
      pgadmin4-desktopmode
      poetry
      pyprland
      rust-analyzer
      sqlite
      tdesktop
      tmux
      tmux-sessionizer
      unstable.basedpyright
      unstable.nekoray
      unstable.spoofdpi
      vscode-fhs
      vscode-langservers-extracted
      warp-terminal
      wl-clipboard
      wl-kbptr
      wlrctl
      xdg-utils
      yaml-language-server
    ];

    stateVersion = "24.05";
  };
}

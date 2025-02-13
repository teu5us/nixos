{
  pkgs,
  unstable,
  config,
  stylix,
  ...
}:

let
  hyprlayout = pkgs.callPackage ./hyprlayout.nix { };
  lz4json = pkgs.callPackage ./lz4json.nix { };
  tmux-sessionizer = pkgs.callPackage ./tmux-sessionizer.nix { };
  vidthumb = pkgs.writeShellScript "vidthumb.sh" ''
    #!/usr/bin/env bash

    if ! [ -f "$1" ]; then
    	exit 1
    fi

    cache="$HOME/.cache/vidthumb"
    index="$cache/index.json"
    movie="$(realpath "$1")"

    mkdir -p "$cache"

    if [ -f "$index" ]; then
    	thumbnail="$(${pkgs.jq}/bin/jq -r ". \"$movie\"" <"$index")"
    	if [[ "$thumbnail" != "null" ]]; then
    		if [[ ! -f "$cache/$thumbnail" ]]; then
    			exit 1
    		fi
    		echo "$cache/$thumbnail"
    		exit 0
    	fi
    fi

    thumbnail="$(uuidgen).jpg"

    if ! ${pkgs.ffmpegthumbnailer}/bin/ffmpegthumbnailer -i "$movie" -o "$cache/$thumbnail" -s 0 2>/dev/null; then
    	exit 1
    fi

    if [[ ! -f "$index" ]]; then
    	echo "{\"$movie\": \"$thumbnail\"}" >"$index"
    fi
    json="$(jq -r --arg "$movie" "$thumbnail" ". + {\"$movie\": \"$thumbnail\"}" <"$index")"
    echo "$json" >"$index"

    echo "$cache/$thumbnail"
  '';
in
{
  disabledModules = [
    "${stylix}/modules/kitty/hm.nix"
    "${stylix}/modules/neovim/hm.nix"
    "${stylix}/modules/cavalier/hm.nix"
  ];

  # nixpkgs.config.allowUnfree = true;

  programs = {
    alacritty = {
      enable = false;
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

    bat.enable = true;

    kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font";
        size = 10;
      };
      themeFile = "tokyo_night_night";
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
        "ctrl+shift+q" = "no_op";
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
      enable = false;
      package = pkgs.emacs29-pgtk;
      extraPackages = (epkgs: with epkgs; [ vterm ]);
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraPackages = with pkgs; [
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

    lf = {
      enable = true;
      settings = {
        cleaner =
          (pkgs.writeShellScript "cleaner.sh" ''
            #!/bin/sh
            exec kitten icat --clear --stdin no --transfer-mode file </dev/null >/dev/tty
          '').outPath;
      };
      previewer.source = pkgs.writeShellScript "previewer.sh" ''
        #!/bin/sh

        draw() {
          kitten icat --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$1" </dev/null >/dev/tty
          exit 1
        }

        file="$1"
        w="$2"
        h="$3"
        x="$4"
        y="$5"

        case "$(file -Lb --mime-type "$file")" in 
          image/*)
            draw "$file"
            ;;
          video/*)
            draw "$(${vidthumb} "$file")"
            ;;
        esac

        pistol "$file"
      '';
    };

    pistol = {
      enable = true;
      associations = [
        {
          mime = "application/json";
          command = "${pkgs.jq}/bin/jq . %pistol-filename%";
        }
        {
          mime = "text/*";
          command = "sh: ${pkgs.bat}/bin/bat --color=always --paging=never %pistol-filename%";
        }
      ];
    };

    zathura = {
      enable = true;
      options = {
        # "default-bg" = "#1a1b26";
        # "default-fg" = "#a9b1d6";
        # "statusbar-fg" = "#a9b1d6";
        # "statusbar-bg" = "#24283b";
        # "inputbar-bg" = "#1a1b26";
        # "inputbar-fg" = "#73daca";
        # "notification-bg" = "#1a1b26";
        # "notification-fg" = "#73daca";
        # "notification-error-bg" = "#1a1b26";
        # "notification-error-fg" = "#f7768e";
        # "notification-warning-bg" = "#1a1b26";
        # "notification-warning-fg" = "#f7768e";
        # "highlight-color" = "#e0af68";
        # "highlight-active-color" = "#9aa5ce";
        # "completion-bg" = "#24283b";
        # "completion-fg" = "#a9b1d6";
        # "completion-highlight-fg" = "#9aa5ce";
        # "completion-highlight-bg" = "24283b";
        # "recolor-lightcolor" = "#16161e";
        # "recolor-darkcolor" = "#a9b1d6";
        "recolor" = "true";
        "recolor-keephue" = "false";
      };
    };

    zed-editor = {
      enable = true;
      userKeymaps = [
        {
          context = "VimControl && !menu";
          bindings = {
            "g shift-f" = "file_finder::Toggle";
          };
        }
      ];
      userSettings = {
        assistant = {
          enabled = true;
          version = "2";
          default_model = {
            provider = "ollama";
            model = "qwen2.5-coder:14b";
          };
        };
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        vim_mode = true;
        ui_font_size = 14;
        buffer_font_family = "FiraCode Nerd Font";
        buffer_font_size = 12;
        theme = {
          mode = "system";
          light = "Tokyo Night";
          dark = "Tokyo Night";
        };
        languages = {
          C = {
            format_on_save = "on";
            formatter = "language_server";
            enable_language_server = true;
          };
          Python = {
            language_servers = [
              "basedpyright"
              "!python"
            ];
          };
        };
        lsp = {
          basedpyright = {
            settings = {
              python = {
                pythonPath = ".venv/bin/python";
              };
              basedpyright.analysis = {
                diagnosticMode = "workspace";
                # inlayHints = { };
              };
            };
          };
        };
        inlay_hints = {
          enable = true;
        };
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };

  xdg.mime.enable = true;

  services = {
    emacs = {
      enable = false;
      package = config.programs.emacs.finalPackage;
      defaultEditor = false;
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
    # theme = {
    #   package = pkgs.tokyonight-gtk-theme;
    #   name = "Tokyonight-Dark";
    # };
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

  stylix = {
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };

  home = {
    username = "suess";
    homeDirectory = "/home/suess";

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      x11.defaultCursor = "left_ptr";
    };

    packages = with pkgs; [
      appimage-run
      black
      chromium
      cliphist
      docker-compose-language-service
      dockerfile-language-server-nodejs
      emmet-ls
      exercism
      nautilus
      sushi
      gopls
      graphviz
      hyprlayout
      hyprshot
      imagemagickBig
      insomnia
      jq
      lz4json
      marksman
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
      basedpyright
      # unstable.ghostty
      nekoray
      vscode-fhs
      vscode-langservers-extracted
      wl-clipboard
      wl-kbptr
      wlrctl
      xdg-utils
      yaml-language-server
      zoom-us
    ];

    stateVersion = "24.05";
  };
}

{ config, pkgs, options, lib, ... }:

let
  aliases = let
    eza = "${pkgs.eza}/bin/eza --group-directories-first";
  in {
    ls = "${eza}";
    ll = "${eza} -l";
    la = "${eza} -a";
    lla = "${eza} -al";
    v = "nvim";
    mkd = "mkdir -pv";
    diff = "diff --color=auto";
    grep = "grep --color=auto";
    cp = "cp -i";
  };
in
{
  programs = {
    bash = {
      enableCompletion = true;
      undistractMe.enable = true;
      shellAliases = aliases;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      histSize = 10000;
      syntaxHighlighting.enable = true;
      autosuggestions = {
        enable = true;
      };
      shellAliases = aliases;
    };
  };

  environment.pathsToLink = [ "/share/zsh" ];
  environment.sessionVariables = {
    PATH = "$PATH:$HOME/.local/bin";
    PROMPT_SFZ_CHAR = "λ";
  };
}

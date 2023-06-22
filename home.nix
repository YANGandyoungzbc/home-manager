{ config, pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> {
    config = { allowUnfree = true; };
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "yang";
  home.homeDirectory = "/home/yang";

  # add other config
  # imports = [ ./foo.nix ]

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  nixpkgs.config = {
    # allow unfree
    allowUnfree = true;
    allowUnfreePredicate = (_:true);
    # 允许的老的, 不安全的包
    # permittedInsecurePackages = [
    #   "openssl-1.1.1u"
    # ];
    # allow nur
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # [[ Packages ]]
    pkgs.nixpkgs-fmt
    pkgs.git
    pkgs.neovim
    pkgs.brave
    pkgs.neofetch
    pkgs.nodejs_20
    pkgs.rustup
    pkgs.xclip
    pkgs.fish
    pkgs.btop
    pkgs.joshuto
    pkgs.lazygit
    pkgs.gh # github cli 可以通过浏览器验证,配合lazygit可以方便的push
    # pkgs.gitui # lazygit 支持vim-like快捷键，这个不支持
    pkgs.zellij
    pkgs.ripgrep
    pkgs.tree

    # unstable
    pkgsUnstable.vscode
    pkgsUnstable.emacs
    pkgsUnstable.firefox-beta-unwrapped

    # nerd font patcher的依赖
    # pkgs.fontforge
    # pkgs.argparse
    # pkgs.python310Packages.fontforge

    ## test
    # pkgs.qq
    # pkgs.nur.repos.linyinfeng.wemeet 不能运行
    ## nur
    # pkgs.nur.repos.xddxdd.dingtalk

    # [[ Fonts ]]
    # default install location is ~/.nix-profile/share/fonts
    # use sudo ln to link it to ~/.local/share/
    pkgs.maple-mono-SC-NF
    pkgs.inconsolata-nerdfont
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/yang/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.home-manager.autoUpgrade.enable = true # 在运行 home-manager switch 之前自动更新 nix-channel
}

{ config, pkgs, lib, ... }:
let
  cfg = config.programs.waybar.mechabar;
in
rec {
  options.programs.waybar.mechabar = with lib; {
    enable = mkEnableOption "mechabar";
    
    modules = mkOption {
      type = types.attrs;
      default = {
        modules-left = [
          "custom/ws"
          "custom/left1"

          "hyprland/workspaces"
          "custom/right1"

          "custom/paddw"
          "hyprland/window"
        ];
        modules-center = [
          "custom/paddc"
          "custom/left2"
          "custom/cpuinfo"

          "custom/left3"
          "memory"

          "custom/left4"
          "cpu"
          "custom/leftin1"

          "custom/left5"
          "custom/distro"
          "custom/right2"

          "custom/rightin1"
          "idle_inhibitor"
          "clock#time"
          "custom/right3"

          "clock#date"
          "custom/right4"

          "custom/wifi"
          "bluetooth"
          "custom/update"
          "custom/right5"
        ];
        modules-right = [
          "mpris"

          "custom/left6"
          "pulseaudio"

          "custom/left7"
          "backlight"

          "custom/left8"
          "battery"

          "custom/leftin2"
          "custom/power"
        ];
      };
      example = literalExpression ''
        {
          modules-left = [ "leftmodule" ];
          modules-center = [ "centermodule1" "centermodule2" ];
          modules-right = [ "rightmodule" ];
        }
      '';
      description = ''
        Modules to use in the waybar config.
      '';
    };
    
    colors = mkOption {
      type = types.attrs;
      default = {};
      example = literalExpression ''
        {
          black = "#000000";
        }
      '';
      description = ''
        An attrset of defined colors for use in the theme
      '';
    };

    themeColors = mkOption {
      type = types.attrs;
      default = {};
      example = literalExpression ''
        {
          module-fg = "@text";
        }
      '';
      description = ''
        An attrset of colors applied to module types
      '';
    };
  };

  config = with lib; mkIf cfg.enable rec {
    home.packages = with pkgs; [
      bluetui
      bluez
      brightnessctl
      pipewire
      rofi-wayland
      nerdfonts
      wireplumber
    ];

    programs.waybar.enable = true;

    programs.waybar.style = ./style.css;
    
    xdg.configFile = {
      rofi = {
        source = ./rofi;
        recursive = true;
      };
      
      "waybar/theme.css".text = let
        themesrc = import ./theme.nix;
        col = lib.concatStrings(lib.attrsets.mapAttrsToList (n: v: "@define-color ${n} ${v};") (themesrc.colors // cfg.colors));
        thcol = lib.concatStrings(lib.attrsets.mapAttrsToList (n: v: "@define-color ${n} ${v};") (themesrc.theme-colors // cfg.themeColors));
        theme = col + thcol;
      in theme;
      
      "waybar/animation.css".source = ./animation.css;

      "waybar/themes" = {
        source = ./themes;
        recursive = true;
      };
      
      "waybar/scripts" = {
        source = ./scripts;
        recursive = true;
        executable = true;
      };
      
      "waybar/config.jsonc".source = mkIf (!programs.waybar?settings) ./config.jsonc;
      };
  };
}
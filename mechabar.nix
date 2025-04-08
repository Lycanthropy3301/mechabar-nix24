{ config, pkgs, lib, ... }:
let
  cfg = config.programs.waybar.mechabar;
in
rec {
  options.programs.waybar.mechabar = {
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
    
    color = mkOption {
      type = types.ints.u8;
      default = 233;
      description = ''
        The hue value of the primary color of the bar
      '';
    };
  };

  home.packages = with pkgs; mkIf cfg.enable [
    bluetui
    bluez
    brightnessctl
    pipewire
    rofi-wayland
    nerdfonts
    wireplumber
  ];

  programs.waybar.enable = mkIf cfg.enable true;

  programs.waybar.style = ./style.css;
  
  xdg.configFile = mkIf cfg.enable {
    rofi = {
      source = ./rofi;
      recursive = true;
    };
    
    "waybar/theme.css".source = let
      themesrc = ./theme.nix { mainColor = cfg.programs.waybar.mechabar.color; };
      theme = themesrc.colors + themesrc.theme-colors;
    in theme;
    
    "waybar/animation.css".source = ./animation.css;

    "waybar/themes" = {
      source = ./waybar/themes;
      recursive = true;
    };
    
    "waybar/scripts" = {
      source = ./scripts;
      recursive = true;
      executable = true;
    };
    
    "waybar/config.jsonc".source = lib.mkIf (!programs.waybar?settings) ./config.jsonc;
  };
}
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

    extraConfig = mkOption {
      type = types.attrs;
      default = {
        mainBar."hyprland/workspaces".persistent-workspaces = {
          "1" = "[]";
          "2" = "[]";
          "3" = "[]";
          "4" = "[]";
          "5" = "[]";
        };
      };
      example = literalExpression ''
        {
          mainBar.memory.tooltip = true;
        }
      '';
      description = ''
        Extra configuration changes to add.
        The main bar is in the mainBar attribute set.
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

    rofiThemeColors = mkOption {
      type = types.attrs;
      default = {};
      example = literalExpression ''
        {
          select-fg = "@text";
        }
      '';
      description = ''
        An attrset of colors applied to the rofi menus
      '';
    };
    
    style = mkOption {
      type = types.path;
      default = ./style.css;
      description = ''
        The style.css file to use
      '';
    };
    
    animation = mkOption {
      type = types.path;
      default = ./animation.css;
      description = ''
        The animation.css file to use
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
      wireplumber
    ];

    programs.waybar.enable = true;

    programs.waybar.style = cfg.style;
    programs.waybar.settings = lib.recursiveUpdate { mainBar = import ./config.nix // cfg.modules; } cfg.extraConfig;
    
    xdg.configFile = {
      rofi = {
        source = ./rofi;
        recursive = true;
      };
      
      "rofi/theme.rasi".text = let
        themesrc = import ./theme.nix;
        col = "* {" + lib.concatStrings(lib.attrsets.mapAttrsToList (n: v: "${n}: ${v};") (themesrc.colors // cfg.colors)) + "}";
        thcol = "* {" + lib.concatStrings(lib.attrsets.mapAttrsToList (n: v: "${n}: ${v};") (themesrc.rofi-theme-colors // cfg.rofiThemeColors)) + "}";
        theme = col + thcol;
      in theme;
      
      "waybar/theme.css".text = let
        themesrc = import ./theme.nix;
        col = lib.concatStrings(lib.attrsets.mapAttrsToList (n: v: "@define-color ${n} ${v};") (themesrc.colors // cfg.colors));
        thcol = lib.concatStrings(lib.attrsets.mapAttrsToList (n: v: "@define-color ${n} ${v};") (themesrc.theme-colors // cfg.themeColors));
        theme = col + thcol;
      in theme;
      
      "waybar/animation.css".source = cfg.animation;

      "waybar/themes" = {
        source = ./themes;
        recursive = true;
      };
      
      "waybar/scripts" = {
        source = ./scripts;
        recursive = true;
        executable = true;
      };
    };
  };
}

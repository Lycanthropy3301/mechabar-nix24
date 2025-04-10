{
  colors = {
    rosewater       = "#f5e0dc";
    flamingo        = "#f2cdcd";
    pink            = "#f5c2e7";
    mauve           = "#cba6f7";
    red             = "#f38ba8";
    maroon          = "#eba0ac";
    peach           = "#fab387";
    yellow          = "#f9e2af";
    green           = "#a6e3a1";
    teal            = "#94e2d5";
    sky             = "#89dceb";
    sapphire        = "#74c7ec";
    blue            = "#89b4fa";
    lavender        = "#b4befe";
    text            = "#cdd6f4";
    subtext1        = "#bac2de";
    subtext0        = "#a6adc8";
    overlay2        = "#9399b2";
    overlay1        = "#7f849c";
    overlay0        = "#6c7086";
    surface2        = "#585b70";
    surface1        = "#45475a";
    surface0        = "#313244";
    base            = "#1e1e2e";
    mantle          = "#181825";
    crust           = "#11111b";

    white           = "#ffffff";
    black           = "#000000";
  };

  /* 
    bg - background
    fg - foreground
    br - border
  */

  theme-colors = {
    shadow          = "shade(@crust, 0.5)";
    main-fg         = "@text";
    main-bg         = "@crust";
    main-br         = "@text";

    active-bg       = "@overlay2";
    active-fg       = "@crust";

    hover-bg        = "@surface0";
    hover-fg        = "alpha(@text, 0.75)";

    /* Module Colors */

    module-fg       = "@text";
    workspaces      = "@mantle";

    cpuinfo         = "@mantle";
    memory          = "@base";
    cpu             = "@surface0";
    distro-fg       = "@black";
    distro-bg       = "@overlay2";
    time            = "@surface0";
    date            = "@base";
    tray            = "@mantle";

    pulseaudio      = "@mantle";
    backlight       = "@base";
    battery         = "@surface0";
    power           = "@overlay2";

    /* State Colors */

    warning         = "@yellow";
    critical        = "@red";
    charging        = "@text";
  };
  
  rofi-theme-colors = {
    main-bg         = "@crust";
    main-fg         = "@text";
    main-br         = "@overlay2";
    input-bg        = "@mantle";
    select-bg       = "@overlay2";
    select-fg       = "@crust";
  }
}
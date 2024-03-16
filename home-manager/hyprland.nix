{ inputs, pkgs, ... }:
let
  hyprlandStartupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    swww init ; swww img ~/SDCard/600091.png &
    ags
    hyprctl setcursor Qogir 24
  '';
  wpctlBin = "${pkgs.wireplumber}/bin/wpctl";
  brightnessctlBin = "${pkgs.brightnessctl}/bin/brightnessctl";
  playerctlBin = "${pkgs.playerctl}/bin/playerctl";
in
{
  home.packages = with pkgs; [
    libnotify
    swww
    kitty
    brightnessctl
    wireplumber
    playerctl
  ];

  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "GNOME Settings";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
    categories = [ "X-Preferences" ];
    terminal = false;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "ags -t launcher";

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = ",preferred,auto,2";

      # Execute your favorite apps at launch
      exec-once = ''${hyprlandStartupScript}/bin/start'';

      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.conf

      # Some default env vars.
      env = [
        "QT_QPA_PLATFORMTHEME,qt6ct" # change to qt6ct if you have that
      ];

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          drag_lock = false;
        };

        sensitivity = 0; # -1.0 to 1.0, 0 means no modification.
        float_switch_override_focus = 2;
      };

      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";

        resize_on_border = true;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 10;

        blur = {
          enabled = true;
          size = 8;
          passes = 1;
          brightness = 0.5;
          vibrancy = 0.5;
          noise = 0.2;
        };

        drop_shadow = true;
        shadow_range = 8;
        shadow_render_power = 2;
        "col.shadow" = "rgba(00000044)";
      };

      animations = {
        enabled = true;

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_is_master = true;
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = true;
        workspace_swipe_numbered = true;
      };

      misc = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        disable_splash_rendering = true;
        force_default_wallpaper = 1; # Set to 0 or 1 to disable the anime mascot wallpapers
      };

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "opacity 0.9 0.8, class:(kitty)"
        "opacity 0.95 1, class:(code-url-handler)"
      ];

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$mod" = "SUPER";

      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mod, Q, exec, $terminal"
        "$mod, C, killactive, "
        "$mod, M, exit, "
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating, "
        "$mod, R, exec, $menu"
        "$mod, P, pseudo, " # dwindle
        "$mod, J, togglesplit, " # dwindle
        # Move focus with mainMod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        # Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        "$mod, Tab, exec, ags -t overview"

        # Scroll through existing workspaces with mainMod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        "$mod SHIFT, R, exec, ags -q; ags"
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList
          (
            x:
            let
              ws =
                let
                  c = (x + 1) / 10;
                in
                builtins.toString (x + 1 - (c * 10));
            in
            [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bindel = [
        ", XF86AudioRaiseVolume,  exec, ${wpctlBin} set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume,  exec, ${wpctlBin} set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp,   exec, ${brightnessctlBin} set +5%"
        ", XF86MonBrightnessDown, exec, ${brightnessctlBin} set  5%-"
      ];
      bindl = [
        ", XF86AudioMute,         exec, ${wpctlBin} set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay,         exec, ${playerctlBin} play-pause"
        ", XF86AudioStop,         exec, ${playerctlBin} stop"
        ", XF86AudioPause,        exec, ${playerctlBin} play-pause"
        ", XF86AudioNext,         exec, ${playerctlBin} next"
        ", XF86AudioPrev,         exec, ${playerctlBin} previous"
      ];

      # plugin = {
      #   hyprbars = {
      #     bar_color = "rgba(2a2a2a)";
      #     bar_height = 28;
      #     col_text = "rgba(ffffffdd)";
      #     bar_text_size = 11;
      #     bar_text_font = "Noto Sans";

      #     buttons = {
      #       button_size = 0;
      #       "col.maximize" = "rgba(ffffff11)";
      #       "col.close" = "rgba(ff111133)";
      #     };
      #   };
      # };
    };
  };
}

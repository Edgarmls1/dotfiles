-----------------
--- AUTOSTART ---
-----------------

hl.on("hyprland.start", function ()
    hl.exec_cmd("dunst")
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd(os.getenv("HOME") .. "/dotfiles/scripts/music-monitor.sh")

    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-Dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
end)

-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_QPA_PLATFORM",      "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-----------------------
----- PERMISSIONS -----
-----------------------

hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")

# dmgbuild settings for the CIAO .dmg installer
#
# Used by build_dmg.sh:
#
#   dmgbuild -s dmg_settings.py -D ver=... -D tmpdir=... -D background=... \
#      "CIAO <ver>" output.dmg
#
# Window/icon layout was taken from the hand-made ciao-hack-DS_Store.

ver = defines["ver"]
tmpdir = defines["tmpdir"]

# Compressed, read-only image on HFS+
format = "UDZO"
filesystem = "HFS+"

# Image size is computed from the files; pass -D size=20g to override
size = defines.get("size", None)

files = [
    f"{tmpdir}/ciao-{ver}",
    f"{tmpdir}/README.txt",
]

symlinks = {"Applications": "/Applications"}

# Copied into the image as /.background.png (hidden by Finder)
background = defines["background"]

show_status_bar = False
show_tab_view = False
show_toolbar = False
show_pathbar = False
show_sidebar = False

# ((x, y), (width, height))
window_rect = ((584, 658), (539, 233))

default_view = "icon-view"
arrange_by = None
show_icon_preview = True
include_icon_view_settings = True
include_list_view_settings = False

icon_size = 112
text_size = 12
label_pos = "bottom"

icon_locations = {
    f"ciao-{ver}": (77, 72),
    "Applications": (296, 70),
    "README.txt": (441, 74),
}

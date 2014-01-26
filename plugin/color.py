#!/usr/bin/env python3

from gi.repository import Gtk, Gdk
import sys

class ColorDialog(Gtk.ColorSelectionDialog):
    def __init__(self, title='Color Picker', color=None):
        Gtk.ColorSelectionDialog.__init__(self, title)

        self.controller = self.get_color_selection()
        self.controller.set_has_opacity_control(True)

        if color is not None:
            self.set_color(color)

    def set_color(self, color):
        rgba = Gdk.RGBA()
        if not rgba.parse(color):
            raise RuntimeError('Invalid color!')
        self.controller.set_current_rgba(rgba)

    @property
    def color(self):
        return self.controller.get_current_rgba()

    @property
    def alpha(self):
        return self.color.alpha

    @property
    def red(self):
        return int(self.color.red * 255)

    @property
    def green(self):
        return int(self.color.green * 255)

    @property
    def blue(self):
        return int(self.color.blue * 255)

    def _same_bytes(self, colors):
        for x in colors:
            if x & 0xF != x >> 4:
                return False

        return True

    def format_color(self):
        a, *colors = self.alpha, self.red, self.green, self.blue

        if a != 1.0:
            return 'rgba(%d, %d, %d, %03.2f)' % tuple(colors + [a])

        if self._same_bytes(colors):
            return '#%x%x%x' % tuple([x & 0xF for x in colors])

        return '#%02x%02x%02x' % tuple(colors)

if len(sys.argv) > 2:
    print >>sys.stderr, 'Usage: %s [color]' % sys.argv[0]
    sys.exit(1)

dlg = ColorDialog('VIM Color Picker')
if len(sys.argv) > 1:
    dlg.set_color(sys.argv[1])

if dlg.run() == Gtk.ResponseType.OK:
    print(dlg.format_color())

dlg.destroy()

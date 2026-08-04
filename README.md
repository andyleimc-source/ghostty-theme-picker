# gt — a live theme picker for Ghostty

Ghostty ships with 460+ themes. Trying one out means editing `config`, hitting
reload, deciding you don't like it, and going again. This makes it a picker:

- **↑↓ previews on your real screen.** Not a swatch in a preview pane — your
  actual prompt, scrollback, and code recolor as you move through the list.
- **Enter applies to every open window and tab**, not just the one you're in.
- **Sorted brightest background first**, so "I need something lighter" or
  "something darker" is a direction you can walk in.

No reload, no restart, no config editing.

```
theme >
↑↓ preview · ←→ page · ^T brightest ^B darkest · type to filter · Enter apply everywhere · Esc revert

   Aa lum 255    Adwaita
   Aa lum 253    GitHub Light Default
   Aa lum 212    Rose Pine Dawn
   Aa lum 204    Belafonte Day
   Aa lum  75    Seoulbones Dark
   Aa lum  63    Zenburn
   Aa lum   0    ENCOM
```

Each row is drawn in that theme's own background and foreground, so the list
itself is a contrast preview.

## Why the brightness sort

This started as a fix for a glossy screen. On a reflective panel a dark theme
turns the display into a mirror — the fix is a background bright enough to wash
the reflection out. Sorting by background luminance turns "find me something
brighter" into scrolling in one direction, and the `lum` number tells you how
far you've moved. If you're picking for eye comfort at night, start at the other
end with `^B`.

## Install

```sh
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/andyleimc-source/ghostty-theme-picker/main/gt \
  -o ~/.local/bin/gt
chmod +x ~/.local/bin/gt
```

Make sure `~/.local/bin` is on your `PATH`. Requires [fzf](https://github.com/junegunn/fzf)
(`brew install fzf`), bash 3.2+ (macOS's system bash is fine), and Ghostty.

## Usage

```sh
gt                  # open the picker
gt "Rose Pine Dawn" # switch straight to a theme by name
gt -l               # print the current theme
gt -h               # help
```

| Key | Action |
| --- | --- |
| `↑` `↓` | move one theme, previewing as you go |
| `←` `→` | page up / down |
| `^U` `^D` | half page up / down |
| `^T` `^B` | jump to the brightest / darkest theme |
| *(type)* | filter by name — `gruv`, `light`, `pine` |
| `Enter` | apply everywhere and save to config |
| `Esc` | revert to what you had |

The picker opens with the cursor on your current theme, so you compare outward
from where you already are.

## How it works

Terminals accept [OSC escape sequences](https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Operating-System-Commands)
that set the palette (`OSC 4`), foreground (`10`), background (`11`), cursor
(`12`), and selection (`17`/`19`) at runtime. `gt` reads a Ghostty theme file,
translates it into those sequences, and writes them to the terminal. That's why
previewing is instant and needs no reload.

Applying to every window uses the same trick, aimed wider: `gt` walks the
process table, keeps the ttys whose ancestor is the Ghostty process, and writes
the sequences to each one. A write to another terminal's tty is rendered by that
terminal, so every Ghostty window and tab repaints at once. The theme is also
written into your config, so windows opened later match.

Reading 460+ theme files happens in a single `awk` pass (~30ms). Doing it with a
couple of `grep`s per file takes closer to three seconds, which you feel every
time the picker opens.

## Known limits

- **tmux panes are skipped.** Inside tmux the terminal is tmux, not Ghostty, so
  color commands sent there don't do what you want. The Ghostty window hosting
  tmux still recolors; the panes follow tmux's own settings.
- **Text already on screen elsewhere waits for a redraw.** Other windows change
  background immediately, but a full-screen TUI keeps its already-drawn colors
  until it repaints.
- **Preview is current-window only.** Fanning out on every keypress while
  walking 463 themes would make every window flicker. Only `Enter` goes wide.
- **Theme files only.** `gt` sets colors, not fonts, padding, or opacity.

## Configuration

| Variable | Meaning |
| --- | --- |
| `GHOSTTY_THEMES_DIR` | override where themes are read from |
| `GHOSTTY_CONFIG` | override which config file is written |
| `GT_LANG` | `en` (default) or `zh` for the picker's UI text |

Theme directories are probed in order, so a theme of your own in
`~/.config/ghostty/themes/` shadows a bundled one with the same name.

## 中文说明

Ghostty 自带 460 多个主题，想换一个得改配置、重载、不喜欢再来一遍。这个脚本
把它变成一个选择器：**上下键在你真实的屏幕上实时预览**（不是小色块，是你的
提示符、滚动历史、代码当场变色），**回车一下所有已打开的窗口和标签页一起变**，
列表**按背景亮度从亮到暗排**。

起因是一块反光很强的玻璃屏：深色主题会把屏幕变成镜子，得靠足够亮的背景把反射
压掉。按亮度排序之后，"再亮一点/再暗一点"就是往一个方向走，行尾的数字告诉你
走了多远。

安装见上面的 Install（需要 fzf）。想要中文界面，在 shell 配置里加一行：

```sh
export GT_LANG=zh
```

## License

MIT

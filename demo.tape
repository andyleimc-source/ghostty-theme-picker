# Demo recording for gt. Rebuild with: vhs demo.tape
#
# Requires vhs (brew install vhs) and a local Ghostty install for its themes.
# Writes to a throwaway config so recording never touches your real one.

Output "demo.gif"

Set Shell bash
Set Width 1240
Set Height 620
Set FontSize 14
Set Padding 24
Set Framerate 20
Set TypingSpeed 60ms

Hide
Type "export PATH=$HOME/.local/bin:$PATH GT_LANG=en GT_SCOPE=window GHOSTTY_CONFIG=/tmp/gt-demo-config"
Enter
Type "printf 'theme = Rose Pine Dawn\n' > /tmp/gt-demo-config"
Enter
Type "PS1='$ '"
Enter
Type "clear"
Enter
Show

Sleep 800ms
Type "gt"
Sleep 400ms
Enter
Sleep 1500ms

# Walk down one theme at a time — the whole screen recolors as the cursor moves.
Down@400ms 7
Sleep 900ms

# Page through with the arrow keys: bright backgrounds down toward dark ones.
Right@900ms 3
Sleep 900ms

# Jump straight to the darkest theme, then back to the brightest.
Ctrl+b
Sleep 1400ms
Ctrl+t
Sleep 1400ms

# Or just type part of a name to filter.
Type@120ms "gruv"
Sleep 1200ms
Down@450ms 3
Sleep 900ms

# Enter applies it: written to the config and pushed to every open window.
Enter
Sleep 2500ms

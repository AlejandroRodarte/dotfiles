import catppuccin

c.tabs.title.format = "{audio}{current_title}"

c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "!yt": "https://youtube.com/results?search_query={}",
}

# dark mode config
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.policy.images = "never"
config.set("colors.webpage.darkmode.enabled", False, "file://*")

# enable catppuccin (manually installed in ~/.config/qutebrowser/catppuccin)
# [these instructions were followed](https://github.com/catppuccin/qutebrowser/tree/main#manual-config)
catppuccin.setup(c, "mocha", False)

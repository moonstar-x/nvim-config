-- Order matters: options (including the leader key) must be set before
-- lazy.nvim loads plugins, so plugin keymaps pick up the right leader.
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

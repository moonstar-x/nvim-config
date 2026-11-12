-- Don't flag at-rules from Tailwind/PostCSS (@tailwind, @apply, @config, ...) as unknown.
local lint = { unknownAtRules = "ignore" }

return {
  settings = {
    css = { lint = lint },
    scss = { lint = lint },
    less = { lint = lint },
  },
}

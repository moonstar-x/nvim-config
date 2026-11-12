local util = require("lspconfig.util")

local tailwind_configs = {
  "tailwind.config.js",
  "tailwind.config.cjs",
  "tailwind.config.mjs",
  "tailwind.config.ts",
}

return {
  -- Only start in projects that use Tailwind: a tailwind.config.* (v3), or a package.json that
  -- depends on tailwindcss / @tailwindcss/* (v4). The default also starts in every git repo.
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local markers = util.insert_package_json(vim.deepcopy(tailwind_configs), "tailwindcss", fname)
    local found = vim.fs.find(markers, { path = fname, upward = true })[1]
    if found then
      on_dir(vim.fs.dirname(found))
    end
  end,
  settings = {
    tailwindCSS = {
      -- Class completion inside these helpers too: cn("..."), cva("..."), clsx("..."), ...
      classFunctions = { "cn", "cva", "cx", "clsx", "twMerge", "tw" },
    },
  },
}

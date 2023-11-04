local M = {}

function M.which_key_register()
  if M.which_key_queue then
    local wk_avail, wk = pcall(require, "which-key")
    if wk_avail then
      for mode, registration in pairs(M.which_key_queue) do
        wk.register(registration, { mode = mode })
      end
      M.which_key_queue = nil
    end
  end
end

function M.set_mappings(map_table, base)
  -- iterate over the first keys for each mode
  base = base or {}
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd = options
        local keymap_opts = base
        if type(options) == "table" then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
          keymap_opts[1] = nil
        end
        if not cmd or keymap_opts.name then -- if which-key mapping, queue it
          if not M.which_key_queue then M.which_key_queue = {} end
          if not M.which_key_queue[mode] then M.which_key_queue[mode] = {} end
          M.which_key_queue[mode][keymap] = keymap_opts
        else -- if not which-key mapping, set it
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
        end
      end
    end
  end
  if package.loaded["which-key"] then M.which_key_register() end -- if which-key is loaded already, register
end

M.set_mappings {
  n = {
    -- window navigation
    ['<C-h>'] = { "<C-w>h" },
    ['<C-j>'] = { "<C-w>j" },
    ['<C-k>'] = { "<C-w>k" },
    ['<C-l>'] = { "<C-w>l" },
    ["<C-Up>"] = { "<cmd>resize -2<CR>", desc = "Resize split up" },
    ["<C-Down>"] = { "<cmd>resize +2<CR>", desc = "Resize split down" },
    ["<C-Left>"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split left" },
    ["<C-Right>"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split right" },
    ['gd'] = { function() require('telescope.builtin').lsp_definitions() end, desc = "go to definition" },
    [";"] = { "<cmd>:HopWord<cr>", desc = "Hop" },
    ["<leader>;"] = { "<cmd>:HopAnywhere<cr>", desc = "Hop!!" },
    ["\\"] = { "<C-w>v", desc = "Vertical Split" },
    ["-"] = { "<C-w>s", desc = "Horizontal Split" },
    ["'"] = { "<cmd>:q<cr>", desc = "Quit" },
    ["<esc>"] = { "^", desc = "go to first non-space" },
    ["t"] = { "<C-w>s<cmd>:terminal<cr>a" },
    ["T"] = { "<C-w>v<cmd>:terminal<cr>a" },
    ["<C-t>"] = { "<cmd>:terminal<cr>" },
    ["H"] = { "<cmd>:bprevious<cr>", desc = "Prev Buffer" },
    ["L"] = { "<cmd>:bnext<cr>", desc = "Next Buffer" },
    ["w"] = { function() require("nvim-window").pick() end, desc = "pick window" },
    [","] = { function() require("telescope.builtin").live_grep() end, desc = "Find words" },
    ["="] = {
      function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end,
      desc = "Find all files",
    },
    ["<leader>fml"] = { "<cmd>CellularAutomaton make_it_rain<cr>", desc = "Fuck my life" },
    ["<leader>'"] = { "<cmd>:edit!<cr>", desc = "Reload buffer" },
    ["<leader>pp"] = { "<cmd>:Telescope projects<cr>", desc = "Telescope projects" },
    ["<leader>lx"] = { "<cmd>:LspRestart<cr>", desc = "LSP Restart" },
    ["<leader>fR"] = { function() require("spectre").open() end, desc = "Spectre search & replace" },
    ["<C-s>"] = { "<cmd>:w!<cr>", desc = "Save File" },
    ["b"] = { function() require("telescope.builtin").buffers() end, desc = "Find buffers" },
    ["<leader>w"] = { "<cmd>w<cr>", desc = "Save" },
    ["<leader>q"] = { "<cmd>confirm q<cr>", desc = "Quit" },
    ["<leader>n"] = { "<cmd>enew<cr>", desc = "New File" },
  },
  t = {
    ["<esc>"] = { "<C-\\><C-n>" },
  },
  i = {
    ["<C-d><C-b>"] = { "import ipdb; ipdb.set_trace(context=5)", desc = "debug" },
  },
}

-- Plugin Manager
local maps = { i = {}, n = {}, v = {}, t = {} }

local sections = {
  f = { desc = "Find" },
  p = { desc = "Packages" },
  l = { desc = "LSP" },
  u = { desc = "UI/UX" },
  b = { desc = "Buffers" },
  bs = { desc = "Sort Buffers" },
  d = { desc = "Debugger" },
  g = { desc = "Git" },
  S = { desc = "Session" },
  t = { desc = "Terminal" },
}
maps.n["<leader>p"] = sections.p
maps.n["<leader>pi"] = { function() require("lazy").install() end, desc = "Plugins Install" }
maps.n["<leader>ps"] = { function() require("lazy").home() end, desc = "Plugins Status" }
maps.n["<leader>pS"] = { function() require("lazy").sync() end, desc = "Plugins Sync" }
maps.n["<leader>pu"] = { function() require("lazy").check() end, desc = "Plugins Check Updates" }
maps.n["<leader>pU"] = { function() require("lazy").update() end, desc = "Plugins Update" }

-- Navigate tabs
maps.n["]t"] = { function() vim.cmd.tabnext() end, desc = "Next tab" }
maps.n["[t"] = { function() vim.cmd.tabprevious() end, desc = "Previous tab" }

maps.n["<leader>/"] = {
  function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
  desc = "Toggle comment line",
}
maps.v["<leader>/"] = {
  "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
  desc = "Toggle comment for selection",
}

maps.n["<leader>g"] = sections.g
maps.n["]g"] = { function() require("gitsigns").next_hunk() end, desc = "Next Git hunk" }
maps.n["[g"] = { function() require("gitsigns").prev_hunk() end, desc = "Previous Git hunk" }
maps.n["<leader>gl"] = { function() require("gitsigns").blame_line() end, desc = "View Git blame" }
maps.n["<leader>gL"] = { function() require("gitsigns").blame_line { full = true } end, desc = "View full Git blame" }

maps.n["<leader>e"] = {
  function()
    if vim.bo.filetype == "neo-tree" then
      vim.cmd.wincmd "p"
    else
      vim.cmd.Neotree "focus"
    end
  end,
  desc = "Explorer",
}

maps.n["<leader>pm"] = { "<cmd>Mason<cr>", desc = "Mason Installer" }
maps.n["<leader>pM"] = { "<cmd>MasonUpdateAll<cr>", desc = "Mason Update" }
maps.n["<leader>lf"] = {
  function() vim.lsp.buf.format(M.format_opts) end,
  desc = "Format buffer",
}
maps.n["<leader>ld"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" }
maps.n["[d"] = { function() vim.diagnostic.goto_prev() end, desc = "Previous diagnostic" }
maps.n["]d"] = { function() vim.diagnostic.goto_next() end, desc = "Next diagnostic" }
maps.n["gl"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" }

-- SymbolsOutline
maps.n["<leader>l"] = sections.l
maps.n["<leader>lS"] = { function() require("aerial").toggle() end, desc = "Symbols outline" }

maps.n["<leader>f"] = sections.f
maps.n["<leader>f<CR>"] = { function() require("telescope.builtin").resume() end, desc = "Resume previous search" }
maps.n["<leader>f'"] = { function() require("telescope.builtin").marks() end, desc = "Find marks" }
maps.n["<leader>fb"] = { function() require("telescope.builtin").buffers() end, desc = "Find buffers" }
maps.n["<leader>fc"] =
{ function() require("telescope.builtin").grep_string() end, desc = "Find for word under cursor" }
maps.n["<leader>fC"] = { function() require("telescope.builtin").commands() end, desc = "Find commands" }
maps.n["<leader>ff"] = { function() require("telescope.builtin").find_files() end, desc = "Find files" }
maps.n["<leader>fF"] = {
  function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end,
  desc = "Find all files",
}
maps.n["<leader>fh"] = { function() require("telescope.builtin").help_tags() end, desc = "Find help" }
maps.n["<leader>fk"] = { function() require("telescope.builtin").keymaps() end, desc = "Find keymaps" }
maps.n["<leader>fm"] = { function() require("telescope.builtin").man_pages() end, desc = "Find man" }
maps.n["<leader>fn"] =
{ function() require("telescope").extensions.notify.notify() end, desc = "Find notifications" }
maps.n["<leader>fo"] = { function() require("telescope.builtin").oldfiles() end, desc = "Find history" }
maps.n["<leader>fr"] = { function() require("telescope.builtin").registers() end, desc = "Find registers" }
maps.n["<leader>ft"] =
{ function() require("telescope.builtin").colorscheme { enable_preview = true } end, desc = "Find themes" }
maps.n["<leader>fw"] = { function() require("telescope.builtin").live_grep() end, desc = "Find words" }
maps.n["<leader>fW"] = {
  function()
    require("telescope.builtin").live_grep {
      additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
    }
  end,
  desc = "Find words in all files",
}
maps.n["<leader>l"] = sections.l
maps.n["<leader>ls"] = {
  function()
    local aerial_avail, _ = pcall(require, "aerial")
    if aerial_avail then
      require("telescope").extensions.aerial.aerial()
    else
      require("telescope.builtin").lsp_document_symbols()
    end
  end,
  desc = "Search symbols",
}

-- Terminal
maps.n["<leader>t"] = sections.t
if vim.fn.executable "lazygit" == 1 then
  maps.n["<leader>g"] = sections.g
  maps.n["<leader>gg"] = {
    function()
      local lazygit = require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
      lazygit:toggle()
    end,
    desc = "ToggleTerm lazygit"
  }
end
-- Stay in indent mode
maps.v["<S-Tab>"] = { "<gv", desc = "Unindent line" }
maps.v["<Tab>"] = { ">gv", desc = "Indent line" }

-- Improved Terminal Navigation
maps.t["<C-h>"] = { "<cmd>wincmd h<cr>", desc = "Terminal left window navigation" }
maps.t["<C-j>"] = { "<cmd>wincmd j<cr>", desc = "Terminal down window navigation" }
maps.t["<C-k>"] = { "<cmd>wincmd k<cr>", desc = "Terminal up window navigation" }
maps.t["<C-l>"] = { "<cmd>wincmd l<cr>", desc = "Terminal right window navigation" }

M.set_mappings(maps)

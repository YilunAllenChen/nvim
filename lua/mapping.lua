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

local sections = {
  f = { desc = "Find" },
  l = { desc = "LSP" },
  u = { desc = "UI/UX" },
  b = { desc = "Buffers" },
  bs = { desc = "Sort Buffers" },
  d = { desc = "Debugger" },
  g = { desc = "Git" },
  S = { desc = "Session" },
  t = { desc = "Terminal" },
}

M.set_mappings {
  n = {
    -- window navigation
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
    ["<leader>b"] = { function() require("telescope.builtin").buffers() end, desc = "Find buffers" },
    ["<leader>w"] = { "<cmd>w<cr>", desc = "Save" },
    ["<leader>q"] = { "<cmd>confirm q<cr>", desc = "Quit" },
    ["<leader>n"] = { "<cmd>enew<cr>", desc = "New File" },
    ["<leader>p"] = { function() require("lazy").home() end, desc = "Plugins" },
    ["]t"] = { function() vim.cmd.tabnext() end, desc = "Next tab" },
    ["[t"] = { function() vim.cmd.tabprevious() end, desc = "Previous tab" },
    ["<leader>/"] = {
      function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Toggle comment line",
    },
    ["]g"] = { function() require("gitsigns").next_hunk() end, desc = "Next Git hunk" },
    ["[g"] = { function() require("gitsigns").prev_hunk() end, desc = "Previous Git hunk" },
    ["<leader>gl"] = { function() require("gitsigns").blame_line() end, desc = "View Git blame" },
    ["<leader>gL"] = { function() require("gitsigns").blame_line { full = true } end, desc = "View full Git blame" },
    ["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Explorer" },
    ["<leader>pm"] = { "<cmd>Mason<cr>", desc = "Mason Installer" },
    ["<leader>pM"] = { "<cmd>MasonUpdateAll<cr>", desc = "Mason Update" },
    ["<leader>g"] = sections.g,

    ["<leader>lf"] = {
      function() vim.lsp.buf.format(M.format_opts) end,
      desc = "Format buffer",
    },
    ["<leader>ld"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
    ["[d"] = { function() vim.diagnostic.goto_prev() end, desc = "Previous diagnostic" },
    ["]d"] = { function() vim.diagnostic.goto_next() end, desc = "Next diagnostic" },

    -- SymbolsOutline
    ["<leader>l"] = sections.l,
    ["<leader>lS"] = { function() require("aerial").toggle() end, desc = "Symbols outline" },

    ["<leader>f"] = sections.f,
    ["<leader>f<CR>"] = { function() require("telescope.builtin").resume() end, desc = "Resume previous search" },
    ["<leader>f'"] = { function() require("telescope.builtin").marks() end, desc = "Find marks" },
    ["<leader>fb"] = { function() require("telescope.builtin").buffers() end, desc = "Find buffers" },
    ["<leader>fc"] = { function() require("telescope.builtin").grep_string() end, desc = "Find for word under cursor" },
    ["<leader>fC"] = { function() require("telescope.builtin").commands() end, desc = "Find commands" },
    ["<leader>ff"] = { function() require("telescope.builtin").find_files() end, desc = "Find files" },
    ["<leader>fF"] = {
      function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end,
      desc = "Find all files",
    },
    ["<leader>fh"] = { function() require("telescope.builtin").help_tags() end, desc = "Find help" },
    ["<leader>fk"] = { function() require("telescope.builtin").keymaps() end, desc = "Find keymaps" },
    ["<leader>fm"] = { function() require("telescope.builtin").man_pages() end, desc = "Find man" },
    ["<leader>fn"] = { function() require("telescope").extensions.notify.notify() end, desc = "Find notifications" },

    ["<leader>fo"] = { function() require("telescope.builtin").oldfiles() end, desc = "Find history" },
    ["<leader>fr"] = { function() require("telescope.builtin").registers() end, desc = "Find registers" },
    ["<leader>ft"] = { function() require("telescope.builtin").colorscheme { enable_preview = true } end, desc =
    "Find themes" },
    ["<leader>fw"] = { function() require("telescope.builtin").live_grep() end, desc = "Find words" },
    ["<leader>fW"] = {
      function()
        require("telescope.builtin").live_grep {
          additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
        }
      end,
      desc = "Find words in all files",
    },
    ["<C-h>"] = { "<cmd>wincmd h<cr>", desc = "Terminal left window navigation" },
    ["<C-j>"] = { "<cmd>wincmd j<cr>", desc = "Terminal down window navigation" },
    ["<C-k>"] = { "<cmd>wincmd k<cr>", desc = "Terminal up window navigation" },
    ["<C-l>"] = { "<cmd>wincmd l<cr>", desc = "Terminal right window navigation" },


    ["<leader>ls"] = {
      function()
        local aerial_avail, _ = pcall(require, "aerial")
        if aerial_avail then
          require("telescope").extensions.aerial.aerial()
        else
          require("telescope.builtin").lsp_document_symbols()
        end
      end,
      desc = "Search symbols",
    },
    ["<leader>gg"] = {
      function()
        local lazygit = require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
        lazygit:toggle()
      end,
      desc = "ToggleTerm lazygit"
    }

  },
  t = {
    ["<esc>"] = { "<C-\\><C-n>" },
    ["<C-h>"] = { "<cmd>wincmd h<cr>", desc = "Terminal left window navigation" },
    ["<C-j>"] = { "<cmd>wincmd j<cr>", desc = "Terminal down window navigation" },
    ["<C-k>"] = { "<cmd>wincmd k<cr>", desc = "Terminal up window navigation" },
    ["<C-l>"] = { "<cmd>wincmd l<cr>", desc = "Terminal right window navigation" },
  },
  i = {
    ["<C-d><C-b>"] = { "import ipdb; ipdb.set_trace(context=5)", desc = "debug" },
  },
  v = {
    ["<leader>/"] = {
      "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
      desc = "Toggle comment for selection",
    },
    ["<S-Tab>"] = { "<gv", desc = "Unindent line" },
    ["<Tab>"] = { ">gv", desc = "Indent line" }
  }

}

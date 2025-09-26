-- A plugin to show keybindings in a popup
return { 'folke/which-key.nvim', event = 'VeryLazy', opts = {
  preset = 'helix',
  icons = { mappings = false },
} }

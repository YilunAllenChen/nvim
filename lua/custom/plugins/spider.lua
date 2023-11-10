-- underscore and camelcase enabled e/w/b motions
return {
  'chrisgrieser/nvim-spider',
  opts = {
    skipInsignificantPunctuation = false,
  },
  keys = {
    { -- example for lazy-loading and keymap
      'e',
      "<cmd>lua require('spider').motion('e')<CR>",
      mode = { 'n', 'o', 'x' },
    },
    {
      'w',
      "<cmd>lua require('spider').motion('w')<CR>",
      mode = { 'n', 'o', 'x' },
    },
    {
      'b',
      "<cmd>lua require('spider').motion('b')<CR>",
      mode = { 'n', 'o', 'x' },
    },
  },
}

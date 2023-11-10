return {
  'Exafunction/codeium.vim',
  tag = '1.4.15',
  lazy = true,
  event = "VeryLazy",
  config = function()
    vim.g.codeium_server_config = {
      portal_url = "https://codeium.des-lab-mt2n-8446.kube.drw",
      api_url = "https://codeium.des-lab-mt2n-8446.kube.drw/_route/api_server"
    }
  end
}

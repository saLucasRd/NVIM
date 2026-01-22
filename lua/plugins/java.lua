return {
  'mfussenegger/nvim-jdtls',
  dependencies = { 'neovim/nvim-lspconfig' },
  ft = { 'java' },
  config = function()
    local jdtls = require 'jdtls'
    local function setup_jdtls()
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      -- Local onde o Neovim guardará os índices do projeto
      local workspace_dir = vim.fn.expand '~/.local/share/nvim/jdtls_workspace/' .. project_name

      local config = {
        cmd = { 'jdtls', '-data', workspace_dir },
        root_dir = jdtls.setup.find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },
        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
              favoriteStaticMembers = {
                'org.junit.jupiter.api.Assertions.*',
                'org.mockito.Mockito.*',
                'org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*',
                'org.springframework.test.web.servlet.result.MockMvcResultMatchers.*',
              },
            },
          },
        },
      }
      jdtls.start_or_attach(config)
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = setup_jdtls,
    })
  end,
}

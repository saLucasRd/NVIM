return {
  'mfussenegger/nvim-jdtls',
  dependencies = { 'neovim/nvim-lspconfig' },
  ft = { 'java' },
  config = function()
    local jdtls = require 'jdtls'

    local function setup_jdtls()
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
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

      local opts = { buffer = true }
      vim.keymap.set('n', '<leader>jo', jdtls.organize_imports, { buffer = true, desc = 'Java: [O]rganize Imports' })
      vim.keymap.set('n', '<leader>jv', jdtls.extract_variable, { buffer = true, desc = 'Java: Extract [V]ariable' })
      vim.keymap.set(
        'v',
        '<leader>jv',
        "<ESC><CMD>lua require('jdtls').extract_variable(true)<CR>",
        { buffer = true, desc = 'Java: Extract Variable (Visual)' }
      )
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = setup_jdtls,
    })
  end,
}

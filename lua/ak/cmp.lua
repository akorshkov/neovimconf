-- configure auto-completion (using nvim-cmp plugin) =======

local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
  return
end

local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
  vim.notify(
  "nvim-cmp plugin requires sippent engine. This config expects " ..
  "'L3MON4D3/LuaSnip' to be installed, but it is not")
  return
end

-- just experiment: display fancy icons in completion list
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    autocomplete = false,   -- invoke autocompleteion only manually
  },
  mapping = {
    ['<C-n>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        cmp.complete()
      end
    end,
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true })
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function (entry, vim_item)
      vim_item.kind = kind_icons[vim_item.kind]
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        buffer = '[Buffer]',
        luasnip = '[Snippet]',
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
}

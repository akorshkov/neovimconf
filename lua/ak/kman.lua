local M = {}

function M.print_my_help()

  print([[
= conf =                             |= diagnostics commands =
:echo $MYVIMRC  <- conf location     |mm - toggle marks column
:PackerSync     <- update plugins    |mk - show diagnostic on floating window
                                     |mn - goto next msg; nM - goto prev msg
                                     |
                                     |gD - goto declaration
                                     |g] - goto definition
                                     |g[ - goto implementation
                                     |<C-k> - show signature
                                     |K  - hover text
]])

end

return M

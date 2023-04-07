-- some tools to be used in this nvim config
local M = {}

-- unfold_config_table returns a new table.
-- entries with numeric keys are substituted in a following way:
-- { "some_name" } => { ["some_name"] = true }
M.unfold_config_table = function(src_table)
  local result_table = {}
  for key, value in pairs(src_table) do
    local entry_name
    local entry_value
    if type(key) == "number" then
      -- corresponds to just a name, value is not specified
      entry_name = value
      entry_value = false
    else
      entry_name = key
      entry_value = value
    end
    result_table[entry_name] = entry_value
  end
  return result_table
end

return M

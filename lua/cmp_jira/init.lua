local source = require("cmp_jira.source")

local M = {}

M.setup = function(overrides)
    require("cmp").register_source("cmp_jira", source.new(overrides))
end

return M

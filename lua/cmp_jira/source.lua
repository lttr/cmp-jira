local cmp = require("cmp")
local curl = require "plenary.curl"
local utils = require("cmp_jira.utils")

local source = {
  config = {},
  filetypes = {},
  cache = {}
}

source.new = function(overrides)
  local self =
      setmetatable(
        {},
        {
          __index = source
        }
      )

  self.config = vim.tbl_extend("force", require("cmp_jira.config"), overrides or {})
  for _, item in ipairs(self.config.filetypes) do
    self.filetypes[item] = true
  end

  -- defaults
  if self.config.jira.jql == nil or self.config.jira.jql == "" then
    self.config.jira.jql = "(assignee = currentUser() OR reporter = currentUser()) order by updated DESC"
  end

  return self
end

function source:is_available()
  return self.filetypes["*"] ~= nil or self.filetypes[vim.bo.filetype] ~= nil
end

function source:complete(_, callback)
  -- try to get the items from cache first before calling the API
  local bufnr = vim.api.nvim_get_current_buf()
  if self.cache[bufnr] then
    callback({ items = self.cache[bufnr] })
    return true
  end

  local req_url = utils.get_request_url(self.config)

  -- run curl command
  curl.get(
    req_url,
    {
      headers = {
        Authorization = utils.get_auth_header()
      },
      callback = function(out)
        local ok, parsed_issues = utils.parse_api_response(out.body)
        if not ok then
          return false
        end
        print(vim.inspect(parsed_issues))

        local items = {}
        for _, issue in ipairs(parsed_issues) do
          table.insert(
            items,
            {
              label = string.format("%s: %s", issue.key, issue.summary),
              filterText = string.format("%s: %s", issue.key, issue.summary),
              insertText = issue.key,
              sortText = issue.key
            }
          )
        end

        -- update the cache
        self.cache[bufnr] = items

        callback({ items = items })
        return true
      end
    }
  )

  return false
end

function source:get_debug_name()
  return "cmp_jira"
end

return source

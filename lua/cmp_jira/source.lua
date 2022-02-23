local cmp = require('cmp')
local Job = require('plenary.job')
local utils = require('cmp_jira.utils')

local source = {
    config = {},
    filetypes = {},
}

source.new = function(overrides)
    local self = setmetatable({}, {
        __index = source,
    })

    self.config = vim.tbl_extend("force", require("cmp_jira.config"), overrides or {})
    for _, item in ipairs(self.config.filetypes) do
        self.filetypes[item] = true
    end

    return self
end

function source:is_available()
        return self.filetypes["*"] ~= nil or self.filetypes[vim.bo.filetype] ~= nil
end

function source:complete(params, callback)
    local user = vim.fn.getenv("JIRA_USER_EMAIL")
    local api_key = vim.fn.getenv("JIRA_USER_API_KEY")
    local url = vim.fn.getenv("JIRA_WORKSPACE_URL")

    local basic_auth = user .. ':' .. api_key

    local req_url = string.format('%s/rest/api/2/search?jql=assignee=marius.svechla\\u0040share-now.com+and+resolution=unresolved&fields=summary', url)

    Job:new({
      command = 'curl',
      args = { '-u', basic_auth, '-XGET', '-H', 'Content-Type: application/json', req_url },
      cwd = '/usr/bin',
      on_exit = function(j, return_val)
        local resp = j:result()[1]
        local ok, parsed_issues = utils.parse_api_response(resp)
        if not ok then
            print("err")
            return false
        end
        print(vim.inspect(parsed_issues))

        local items = {}
        for _, i in ipairs(parsed_issues) do
            table.insert(items, {
                label = i.key,
                labelDetails = {
                    description = i.summary,
                },
                insertText = i.key,
                word = i.key,
            })
        end

        callback({ items = items })
      end,
    }):sync() -- or start()


    return false
end

function source:get_debug_name()
    return "cmp_jira"
end

return source

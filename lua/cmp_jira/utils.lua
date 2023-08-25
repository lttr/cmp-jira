local M = {}

M.parse_api_response = function(response)
    local ok, parsed = pcall(vim.json.decode, response)
    if not ok then
        return false, {}
    end

    if not parsed.issues then
        return false, {}
    end

    local issues = {}
    for _, issue in ipairs(parsed.issues) do

        if not issue.key then
            return false, {}
        end

        local summary_val = ''
        if issue.fields then
            if issue.fields.summary then
              summary_val = issue.fields.summary
            end
        end

       table.insert(issues, {
           key = issue.key,
           summary = summary_val,
       })
    end

    return true, issues
end

M.get_basic_auth = function(config)
    local user = M.get_user(config)
    local api_key = vim.fn.getenv("JIRA_USER_API_KEY")
    return user .. ':' .. api_key
end

M.get_auth_header = function(config)
    local api_key = vim.fn.getenv("JIRA_USER_API_KEY")
    return string.format("Bearer %s", api_key)
end

M.get_request_url = function(config)
    local url = M.get_jira_url(config)
    local jql = M.get_jql(config)
    return string.format('%s/rest/api/2/search?fields=summary&jql=', url) ..  jql
end

M.get_jql = function(config)
    local username = M.get_username(config)
    return string.format(config.jira.jql, username)
end

M.get_jira_url = function(config)
    local url = config.jira.url
    if vim.fn.exists("$JIRA_WORKSPACE_URL") == 1 then
        url = vim.fn.getenv("JIRA_WORKSPACE_URL")
    end
    return url
end

M.get_user = function(config)
    local user = config.jira.email
    if vim.fn.exists("$JIRA_USER_EMAIL") == 1 then
        user = vim.fn.getenv("JIRA_USER_EMAIL")
    end
    return user
end

M.get_username = function(config)
    local user = M.get_user(config)
    return string.gsub(user, "@", "\\u0040")
end

return M

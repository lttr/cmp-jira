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

return M

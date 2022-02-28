# cmp-jira

[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) completion source for Jira.

## Getting started

Use your favorit plugin manager to install the plugin:

```lua
use 'https://gitlab.com/msvechla/cmp-jira.git'
```

Then setup the cmp source by following these steps:

```lua
require'cmp'.setup {
  sources = {
    { name = 'cmp_jira' }
  }
}

require("cmp_jira").setup()
```

## Configuration

To authenticate to the JIRA API, an API-Key is required.
Setup your API-Key at: <https://id.atlassian.com/manage/api-tokens>

Then set the `JIRA_USER_API_KEY` environment variable, e.g.:

```bash
export JIRA_USER_API_KEY='MyAPIKey'
```

Additionally, the following can be configured via environment variables:

```bash
export JIRA_WORKSPACE_URL=https://jira.example.com
export JIRA_USER_EMAIL=test.user@example.com
```

Alternatively the workspace `url` and `email` can be configured during the setup as well:

```lua
require("cmp_jira").setup({
    file_types = {"gitcommit"}
    jira = {
        -- email: optional, alternatively specify via $JIRA_USER_EMAIL
        email = "test.user@example.com"
        -- url: optional, alternatively specify via $JIRA_WORKSPACE_URL
        url = "https://jira.example.com"
        -- jql: optional, lua format string, escaped username/email will be passed to string.format()
        jql = "assignee=%s+and+resolution=unresolved"
    }
})
```

To filter the issues that are retrieved, you can optionally tweak the [JQL](https://support.atlassian.com/jira-service-management-cloud/docs/use-advanced-search-with-jira-query-language-jql/).

The `config.jql` is treated as a lua format string, which will get the escaped username/email passed.
Defaults to: `assignee=%s+and+resolution=unresolved`


## Acknowledgements

- inspired by [coc-jira-complete](https://github.com/jberglinds/coc-jira-complete)
- inspired by [cmp-git](https://github.com/petertriho/cmp-git)
- thanks to [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) for curl support & the testing framework


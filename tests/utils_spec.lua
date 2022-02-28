describe("utils", function()
    local utils = require('cmp_jira.utils')

    it("can parse sample correct api response", function()
        ok, issues = utils.parse_api_response([[
            {
  "expand": "schema,names",
  "startAt": 0,
  "maxResults": 50,
  "total": 2,
  "issues": [
    {
      "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
      "id": "335410",
      "self": "https://testing.com/rest/api/2/issue/1",
      "key": "AWESOME-1337",
      "fields": {
        "summary": "test summary 1"
      }
    },
    {
      "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
      "id": "335408",
      "self": "https://testing.com/rest/api/2/issue/2",
      "key": "TEST-42",
      "fields": {
        "summary": "test summary 2"
      }
    }
  ]
}
]])

    assert.equals(true, ok)
    assert.same({
        {
            key = "AWESOME-1337",
            summary = "test summary 1",
        },
        {
            key = "TEST-42",
            summary = "test summary 2",
        },
    }, issues)

        end)

    it("returns error with incorrect api response", function()
        ok, issues = utils.parse_api_response([[
            {
]])

    assert.equals(false, ok)
    assert.same({}, issues)

    end)

    it("parses with missing summary value", function()
        ok, issues = utils.parse_api_response([[
            {
  "issues": [
    {
      "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
      "id": "335410",
      "self": "https://testing.com/rest/api/2/issue/1",
      "key": "AWESOME-1337",
      "wasd": {
        "asd": "test summary 1"
      }
    },
    {
      "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
      "id": "335408",
      "self": "https://testing.com/rest/api/2/issue/2",
      "key": "TEST-42",
      "fields": {
        "summary": "test summary 2"
      }
    }
  ]
}
]])

    assert.equals(true, ok)
    assert.same({
        {
            key = "AWESOME-1337",
            summary = "",
        },
        {
            key = "TEST-42",
            summary = "test summary 2",
        },
    }, issues)

    end)

    it("errors with missing issue key", function()
        ok, issues = utils.parse_api_response([[
            {
  "issues": [
    {
      "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
      "id": "335410",
      "self": "https://testing.com/rest/api/2/issue/1",
      "wasd": {
        "asd": "test summary 1"
      }
    },
    {
      "expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields",
      "id": "335408",
      "self": "https://testing.com/rest/api/2/issue/2",
      "key": "TEST-42",
      "fields": {
        "summary": "test summary 2"
      }
    }
  ]
}
]])

    assert.equals(false, ok)
    assert.same({}, issues)

    end)

    it("can get user", function()
        local user = utils.get_user({
            jira = {
                email = "test.user@example.com"
            },
        })

        assert.equals("test.user@example.com", user)
    end)

    it("can get username", function()
        local user = utils.get_username({
            jira = {
                email = "test.user@example.com"
            },
        })

        assert.equals("test.user\\u0040example.com", user)
    end)

    it("can get jira url", function()
        local url = utils.get_jira_url({
            jira = {
                url = "https://jira.example.com"
            },
        })

        assert.equals("https://jira.example.com", url)
    end)

end)

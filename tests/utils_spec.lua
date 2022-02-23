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

end)

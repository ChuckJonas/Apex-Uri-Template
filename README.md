# Apex UriTemplate

Allows matching and parsing of template URI in Salesforce's Apex. Developed to assist in URL routing and parsing for RestResources.

_Example:_

```java
UriTemplate uriTemplate = new UriTemplate('/api/:version/account/:accNum');
UriTemplate.Match match = uriTemplate.parse('/api/v1/account/1234');
if(match != null){            //returns null if no match
  System.debug(match.params); // { version => v1, accNum => 1234}
}
```

Based loosely on the [path-to-regexp npm library](https://github.com/pillarjs/path-to-regexp) (but with waaay less features).

## Features

-   parses URI template params
    -- optional modifier `/account/:id?`
-   parses URL query params. EX: `?name=foo` == `{ name => foo }`
-   parses hash

## Limitations

-   Does not support protocols (`https://`)
-   Pretty much anything else that `path-to-regexp` can do and that isn't listed above ;)

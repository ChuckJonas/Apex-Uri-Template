# Apex UriTemplate

Allows matching and parsing of simple Template URI in Salesforce's Apex. Developed to assist in URL routing and parsing for RestResources.

_Example:_

```java
UriTemplate uriTemplate = new UriTemplate('/api/:version/account/:accNum');
UriTemplate.Match match = uriTemplate.parse('/api/v1/account/1234');
if(match != null){            //returns null if no match
  System.debug(match.params); // { version => v1, accNum => 1234}
}
```

Based loosely on [path-to-regexp npm library](https://github.com/pillarjs/path-to-regexp) and [Microsofts URITemplate](https://docs.microsoft.com/en-us/dotnet/framework/wcf/feature-details/uritemplate-and-uritemplatetable) (but waaay more limited).

## Features

-   parses URI template "Named Parameters" (`/account/:id`)
    -- optional modifier `/account/:id?`
-   parses URL query params. EX: `?name=foo` == `{ name => foo }`
-   parses hash

## Limitations

-   Does not support protocols (`https://`)
-   Each "Named Parameter" must be delimited by `/` or `.`

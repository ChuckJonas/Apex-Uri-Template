# Apex UriTemplate

Allows defining and testing & parsing simple "Template URI" in Salesforce's Apex. Developed primarily to assist in URL routing.

[Install (04t1C000000ODlfQAG)](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t1C000000ODlfQAG)

## Example Use Cases

**Template:** `/api/:version/account/:id`

Input: `/api/v2/account/123`

```js
{
    params: { version: 'v2', id: '123' }
}
```

**Template:** `/imgs/:name.:ext`

Input: `/imgs/foo.png`

<!-- prettier-ignore -->
```js
{
    params: { name: 'foo', ext: 'png' }
}
```

**Template:** `/images/foo-:num.jpg`

Input: `/imgs/foo-123.png?size=100`

<!-- prettier-ignore -->
```js
{
    params: { num: '123' },
    qry: { size: '100' }
}
```

**Template:** `/foo`

Input: `/foo?bar=123#abc`

<!-- prettier-ignore -->
```js
{
    qry: { bar:  '123' },
    hash: 'abc'
}
```

NOTE: Based loosely on [path-to-regexp npm library](https://github.com/pillarjs/path-to-regexp) and [Microsofts URITemplate](https://docs.microsoft.com/en-us/dotnet/framework/wcf/feature-details/uritemplate-and-uritemplatetable) (but waaay more limited).

## Usage

```java
// defined template
UriTemplate uriTemplate = new UriTemplate('/api/:version/account/:accNum');
// use template
UriTemplate.Match match = uriTemplate.parse('/api/v1/account/1234?data=all');
if(match != null){            // null if no match
  System.debug(match.params); // { version => 'v1', accNum => '1234'}
  System.debug(match.qry);    // { data => 'all' }
  System.debug(match.hash);   // null
}
```

### `UriTemplate.Match` fields

-   `params` (`Map<String, String>`): keys are the names you defined in your template. `null` if "Named Parameters" were not defined.
-   `qry` (`Map<String, String>`): parsed url params `?key=value` == `{key => value}`. `null` if no query is present.
-   `hash` (`String`): captures everything after `#`. `null` if no `#` is present.

## Template syntax

-   `/foo/bar` Literal match of `/foo/bar`
-   `/foo/:bar` Named Parameter
-   `/foo/:bar?` Optional Named Parameter
-   `/foo/:abc*` Named Parameter wildcard.  Will match to end of URL (until query params `?`). Only allowed as last character of template.  Result will be stored in `abc` Named Parameter
-   `/foo/*` same as above, but result will be stored in `*` Named Parameter

See `UriTemplateTests` for more complete usage examples.

### Limitations

-   Does not support protocols (`https://`)
-   Each "Named Parameter" must be isolated by one of the following (`/`, `.`, `-`). For example: `/image-:num.png` works, but `/image:num.png` is not currently supported.
-   Does not support non-named capture groups. EG: `foo/(.*)/:foo` is not supported.
-   embedding Regex directly in the template may or may not work (not officially supported at the moment)
-   Only supports parsing. Uri "building" may be added at some point
-   Cannot restrict Query String format

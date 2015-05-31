



`InternalTests` performs tests for internal logics which are hard to be
tested with public interfaces.











URL Query String
----------------
Query string fields formatted like `?a=b&c=d` is defined by HTML, not RFC.
Current standard for URI is `RFC 3986`, and it does not define any form-
field style query string. The only definition is strings between `?` and 
`#` are query string.

To follow this, special query-string handling in this library has been 
removed. Just use `NSURL` to process such stuffs. 

Anyway, those form-field style query string formatting is defined in HTML,
then you can find related stuffs in `HTML.Form.URLEncoded`.
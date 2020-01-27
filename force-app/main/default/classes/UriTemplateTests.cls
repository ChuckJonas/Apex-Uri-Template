@isTest
public class UriTemplateTests {
    @isTest
    private static void onePath() {
        UriTemplate uri = new UriTemplate('/foo');
        UriTemplate.Match m = uri.parse('/foo');
        System.assertNotEquals(null, m);
        m = uri.parse('/foo/');
        System.assertNotEquals(null, m);
        System.assertEquals(null, m.params);
        System.assertEquals(null, m.qry);
        System.assertEquals(null, m.hash);
        m = uri.parse('/bar');
        System.assertEquals(null, m);
    }

    @isTest
    private static void wildCardParam() {
        UriTemplate uri = new UriTemplate('/v1/customer/:customerId/:route*');

        UriTemplate.Match m = uri.parse('/v1/customer/123/accounts');
        System.assertNotEquals(null, m);
        system.assertEquals('123', m.params.get('customerId'));
        system.assertEquals('accounts', m.params.get('route'));

        m = uri.parse('/v1/customer/123/accounts/testing/a/long/route');
        System.assertNotEquals(null, m);
        system.assertEquals('123', m.params.get('customerId'));
        system.assertEquals('accounts/testing/a/long/route', m.params.get('route'));

        m = uri.parse('/v1/customer/123/accounts/testing?id=hello#world');
        System.assertNotEquals(null, m);
        system.assertEquals('123', m.params.get('customerId'));
        system.assertEquals('accounts/testing', m.params.get('route'));
        system.assertEquals('hello', m.qry.get('id'));
        system.assertEquals('world', m.hash);
    }

    @isTest
    private static void wildCardIndepedent() {
        UriTemplate uri = new UriTemplate('/v1/customer/:customerId/*');

        UriTemplate.Match m = uri.parse('/v1/customer/123/accounts');
        System.assertNotEquals(null, m);
        system.assertEquals('123', m.params.get('customerId'));
        system.assertEquals('accounts', m.params.get('*'));

        m = uri.parse('/v1/customer/123/accounts/testing/a/long/route');
        System.assertNotEquals(null, m);
        system.assertEquals('123', m.params.get('customerId'));
        system.assertEquals('accounts/testing/a/long/route', m.params.get('*'));

        m = uri.parse('/v1/customer/123/accounts/testing?id=hello#world');
        System.assertNotEquals(null, m);
        system.assertEquals('123', m.params.get('customerId'));
        system.assertEquals('accounts/testing', m.params.get('*'));
        system.assertEquals('hello', m.qry.get('id'));
        system.assertEquals('world', m.hash);
    }

    @isTest
    private static void wildNotAllowed() {
      try{
        UriTemplate uri = new UriTemplate('foo*/');
        System.assert(false, 'should have thrown TokenException exception');
      }catch(UriTemplateParser.ParseException e){}
    }

    @isTest
    private static void notStartsWithSlash() {
        UriTemplate uri = new UriTemplate('foo');
        UriTemplate.Match m = uri.parse('foo');
        System.assertNotEquals(null, m);
        m = uri.parse('/foo/');
        System.assertEquals(null, m);
    }

    @isTest
    private static void endsWithSlash() {
        UriTemplate uri = new UriTemplate('foo/');
        UriTemplate.Match m = uri.parse('foo/');
        System.assertNotEquals(null, m);
        m = uri.parse('/foo/');
        System.assertEquals(null, m);
    }

    @isTest
    private static void doubleSlash() {
        UriTemplate uri = new UriTemplate('foo//abc');
        UriTemplate.Match m = uri.parse('foo//abc');
        System.assertNotEquals(null, m);
        m = uri.parse('foo/abc');
        System.assertEquals(null, m);
    }

    @isTest
    private static void dash() {
        UriTemplate uri = new UriTemplate('img-:num.png');
        UriTemplate.Match m = uri.parse('img-123.png');
        System.assertNotEquals(null, m);
        System.assertEquals('123', m.params.get('num'));
        m = uri.parse('img-123.jpg');
        System.assertEquals(null, m);
    }

    @isTest
    private static void onePathOneGroup() {
        UriTemplate uri = new UriTemplate('/foo/:name');
        UriTemplate.Match m = uri.parse('/foo/abc');
        System.assertNotEquals(null, m);
        System.assertEquals('abc', m.params.get('name'));
        m = uri.parse('/bar/abc');
        System.assertEquals(null, m);
    }

    @isTest
    private static void extension() {
        UriTemplate uri = new UriTemplate('/foo.png');
        UriTemplate.Match m = uri.parse('/foo.png');
        System.assertNotEquals(null, m);
    }

    @isTest
    private static void nameAndExtension() {
        UriTemplate uri = new UriTemplate('/foo/:name.:ext');
        UriTemplate.Match m = uri.parse('/foo/one.jpg');
        System.assertNotEquals(null, m);
        System.assertEquals('one', m.params.get('name'));
        System.assertEquals('jpg', m.params.get('ext'));
    }

    @isTest
    private static void extensionTemplate() {
        UriTemplate uri = new UriTemplate('/foo.:ext');
        UriTemplate.Match m = uri.parse('/foo.png');
        System.assertNotEquals(null, m);
        System.assertEquals('png', m.params.get('ext'));
    }

    @isTest
    private static void groupOptional() {
        UriTemplate uri = new UriTemplate('/foo/:bar?');
        UriTemplate.Match m = uri.parse('/foo');
        System.assertNotEquals(null, m);
        m = uri.parse('/foo/');
        System.assertNotEquals(null, m);
        m = uri.parse('/foo/123');
        System.assertNotEquals(null, m);
        System.assertEquals('123', m.params.get('bar'));
    }

    @isTest
    private static void groupOptional2() {
        UriTemplate uri = new UriTemplate('/foo/:bar?/foo');
        UriTemplate.Match m = uri.parse('/foo/foo');
        System.assertNotEquals(null, m);
        m = uri.parse('/foo/123/foo/');
        System.assertNotEquals(null, m);
        System.assertEquals('123', m.params.get('bar'));
    }

    @isTest
    private static void groupOptional3() {
        UriTemplate uri = new UriTemplate('/:bar?/foo');
        UriTemplate.Match m = uri.parse('/foo');
        System.assertNotEquals(null, m);
        m = uri.parse('/123/foo/');
        System.assertNotEquals(null, m);
        System.assertEquals('123', m.params.get('bar'));
    }

    @isTest
    private static void groupOptional4() {
        UriTemplate uri = new UriTemplate('/:bar/:foo?');
        UriTemplate.Match m = uri.parse('/123');
        System.assertNotEquals(null, m);
        System.assertEquals('123', m.params.get('bar'));
        m = uri.parse('/123/456');
        System.assertNotEquals(null, m);
        System.assertEquals('123', m.params.get('bar'));
        System.assertEquals('456', m.params.get('foo'));
    }

    @isTest
    private static void twoGroups() {
        UriTemplate uri = new UriTemplate('/:one/:two');
        UriTemplate.Match m = uri.parse('/foo/bar/');
        System.assertNotEquals(null, m);
        System.assertEquals('foo', m.params.get('one'));
        System.assertEquals('bar', m.params.get('two'));
    }

    @isTest
    private static void twoPathsTwoGroups() {
        UriTemplate uri = new UriTemplate('/my/:one/:two/path');
        UriTemplate.Match m = uri.parse('/my/foo/bar/path');
        System.assertNotEquals(null, m);
        System.assertEquals('foo', m.params.get('one'));
        System.assertEquals('bar', m.params.get('two'));
    }

    @isTest
    private static void twoPathsTwoGroups2() {
        UriTemplate uri = new UriTemplate('/my/:one/path/:two');
        UriTemplate.Match m = uri.parse('/my/foo/path/bar');
        System.assertNotEquals(null, m);
        System.assertEquals('foo', m.params.get('one'));
        System.assertEquals('bar', m.params.get('two'));
    }

    @isTest
    private static void testQryAndHashEmpty() {
        UriTemplate uri = new UriTemplate('/foo');
        UriTemplate.Match m = uri.parse('/foo?#');
        System.assertNotEquals(null, m);
        System.assertEquals(0, m.qry.size());
        System.assertEquals('', m.hash);
    }

    @isTest
    private static void testQry() {
        UriTemplate uri = new UriTemplate('/foo');
        UriTemplate.Match m = uri.parse('/foo?bar=baz&fam=lit');
        System.assertNotEquals(null, m);
        System.assertEquals(2, m.qry.size());
        System.assertEquals('baz', m.qry.get('bar'));
        System.assertEquals('lit', m.qry.get('fam'));
        System.assertEquals(null, m.hash);
        System.assertEquals(null, m.params);
    }

    @isTest
    private static void testQryWithSlash() {
        UriTemplate uri = new UriTemplate('/foo');
        UriTemplate.Match m = uri.parse('/foo/?bar=baz&fam=lit');
        System.assertNotEquals(null, m);
        System.assertEquals(2, m.qry.size());
        System.assertEquals('baz', m.qry.get('bar'));
        System.assertEquals('lit', m.qry.get('fam'));
        System.assertEquals(null, m.hash);
        System.assertEquals(null, m.params);
    }

    @isTest
    private static void testHash() {
        UriTemplate uri = new UriTemplate('/foo');
        UriTemplate.Match m = uri.parse('/foo#bar');
        System.assertNotEquals(null, m);
        System.assertEquals('bar', m.hash);
        System.assertEquals(null, m.qry);
        System.assertEquals(null, m.params);
    }
}

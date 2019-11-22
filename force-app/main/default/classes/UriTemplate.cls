//Author: charlie@callaway.cloud
//  Description: Define, test and parse template URL

//
public class UriTemplate {
    public System.Pattern regex;
    private Map<Integer, String> namedParameters;

    /** Constructor
     *  @template the URI Template to build.
     *   See readme for supported template syntax
     */
    public UriTemplate(String template) {
        UriTemplateTokenizer tokenizer = new UriTemplateTokenizer();
        UriTemplateParser p = new UriTemplateParser(tokenizer.scan(template));
        p.parse();
        this.regex = p.regex;
        this.namedParameters = p.namedParameterCaptures;
    }

    // /foo:ext/

    public Match parse(String url) {
        System.Matcher matcher = regex.matcher(url);
        if (matcher.matches()) {
            Integer namedCaptures = namedParameters.size();
            Match mr = new Match();

            //parse uri named captures
            if (namedCaptures > 0) {
                mr.params = new Map<String, String>();
                for (Integer index : namedParameters.keySet()) {
                    String name = namedParameters.get(index);
                    mr.params.put(name, matcher.group(index));
                }
            }

            // Below here will need to be refactored to allowed non name-param groups
            // qry & hash should always be last 2 groups respectively

            //parse query string
            String qry = matcher.group(namedCaptures + 1);
            if (qry != null) {
                mr.qry = new Map<String, String>();
                qry = qry.substring(1, qry.length());
                for (String keyValue : qry.split('&')) {
                    String[] parts = keyValue.split('=');
                    if (parts.size() == 2) {
                        mr.qry.put(parts[0], parts[1]);
                    }
                }
            }

            //set hash
            String hash = matcher.group(namedCaptures + 2);
            if (hash != null) {
                mr.hash = hash.substring(1, hash.length());
            }
            return mr;
        }

        return null;
    }

    public class Match {
        public Map<String, String> params;
        public String hash;
        public Map<String, String> qry;
    }
}

//Author: charlie@callaway.cloud
//  Description: UriTemplate parser.
//   NOTE: This would be much cleaner as a LR parser
//
public with sharing class UriTemplate {
    public System.Pattern regex;
    private String[] namedParameters;

    public UriTemplate(String uriTemplate) {
        String[] parts = uriTemplate.split('(?=[\\/|\\.])');
        String regexStr = '^';
        namedParameters = new List<String>{};
        for (Integer i = 0; i < parts.size(); i++) {
            String part = parts[i];
            String delimeter;
            if (part.startsWith('/') || part.startsWith('.')) {
                delimeter = part.substring(0, 1);
                part = part.substring(1, part.length());
            }

            if (part.startsWith(':')) {
                String captureName = part.substring(1, part.length());
                regexStr += '(?:\\' + delimeter + '([^\\/#\\?]+?))';
                if (part.endsWith('?')) {
                    regexStr += '?';
                    captureName = captureName.substring(
                        0,
                        captureName.length() - 1
                    );
                }
                namedParameters.add(captureName);
            } else {
                regexStr += (delimeter != null ? '\\' + delimeter : '') + part;
            }
        }
        regexStr += '[\\/]?(\\?[^\\/#]*)?(#.*)?$';
        regex = Pattern.compile(regexStr);
    }

    public Match parse(String url) {
        System.Matcher matcher = regex.matcher(url);
        if (matcher.matches()) {
            Integer namedCaptures = namedParameters.size();
            Match mr = new Match();

            //parse uri named captures
            if (namedCaptures > 0) {
                mr.params = new Map<String, String>();

                for (Integer i = 0; i < namedCaptures; i++) {
                    String name = namedParameters[i];
                    mr.params.put(name, matcher.group(i + 1));
                }
            }

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

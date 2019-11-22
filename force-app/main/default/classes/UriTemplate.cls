public with sharing class UriTemplate {
    public System.Pattern regex;
    public String[] captureNames;

    public UriTemplate(String uriTemplate) {
        String[] parts = uriTemplate.split('\\/');
        String regexStr = '^';
        captureNames = new List<String>{};
        for (Integer i = 0; i < parts.size(); i++) {
            String part = parts[i];
            if (part.startsWith(':')) {
                String captureName = part.substring(1, part.length());
                regexStr += '(?:\\/([^\\/#\\?]+?))';
                if (part.endsWith('?')) {
                    regexStr += '?';
                    captureName = captureName.substring(
                        0,
                        captureName.length() - 1
                    );
                }
                captureNames.add(captureName);
            } else if (!String.isEmpty(part)) {
                regexStr += (i == 0 ? '' : '\\/') + part;
            } else {
                regexStr += (i == 0 ? '' : '\\/');
            }
        }
        regexStr += '[\\/]?(\\?[^\\/#]*)?(#.*)?$';
        regex = Pattern.compile(regexStr);
    }

    public Match parse(String url) {
        System.Matcher matcher = regex.matcher(url);
        if (matcher.matches()) {
            Integer namedCaptures = captureNames.size();
            Match mr = new Match();

            //parse uri named captures
            if (namedCaptures > 0) {
                mr.params = new Map<String, String>();

                for (Integer i = 0; i < namedCaptures; i++) {
                    String name = captureNames[i];
                    system.debug(matcher);
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

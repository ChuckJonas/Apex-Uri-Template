//Author: charlie@callaway.cloud
//  Description: Creates List[] tokens for given expression
//
public class UriTemplateTokenizer {
    private StringReader reader;

    public List<UriTemplateToken> scan(string expression) {
        reader = new StringReader(expression);

        List<UriTemplateToken> tokens = new List<UriTemplateToken>();
        while (reader.canRead()) {
            String c = reader.Peek();
            if (c.isWhitespace()) {
                reader.Read();
                continue;
            }

            if (isDelimeter(c)) {
                tokens.Add(new UriTemplateToken.DelimiterToken(c));
                reader.Read();
            } else if (c == ':') {
                //read until we get to the end
                tokens.Add(new UriTemplateToken.StartNameParamToken());
                reader.Read();
            } else if (c == '?') {
                tokens.Add(new UriTemplateToken.OptionalNameParamToken());
                reader.Read();
            } else if (isIdenifier(c)) {
                string s = parseIdentifier();
                tokens.Add(new UriTemplateToken.IdentifierToken(s));
            } else {
                throw new TokenException(
                    'Unknown character in expression: ' + c
                );
            }
        }

        return tokens;
    }

    private string parseIdentifier() {
        String id = '';
        while (reader.canRead() && isIdenifier(reader.Peek())) {
            String s = reader.Read();
            id += s;
        }

        return id;
    }

    private boolean isDelimeter(String c) {
        return c == '/' | c == '.' | c == '-';
    }

    private boolean isIdenifier(string c) {
        return !(isDelimeter(c) || c == '?');
    }

    public class TokenException extends Exception {
    }
}

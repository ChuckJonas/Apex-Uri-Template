//Author: charlie@callaway.cloud
//  Description: Parses Tokens into a Regular Expression + Named Capture Groups
//
// === BNF (ish) ===
// Expression     := {Delimeter} Segement {Delimeter Segement}
// Segement       := Idenifiter | NameParameter
// NameParameter  := ":" Idenifiter {"?"}
// Delimeter      := "/" | "." | "-"
// Idenifiter      := "A-Z 1-9".*
public class UriTemplateParser {
    private List<UriTemplateToken> tokens;

    private Integer index = -1;
    private Integer captureGroup = 0;

    public Map<Integer, String> namedParameterCaptures;
    public Pattern regex;

    public UriTemplateParser(List<UriTemplateToken> tokens) {
        this.tokens = tokens;
        namedParameterCaptures = new Map<Integer, String>();
    }

    public void parse() {
        String regexStr = '^';
        while (moveNext()) {
            regexStr += parseSegment();
        }
        regexStr += '[\\/]?(\\?[^\\/#]*)?(#.*)?$';
        regex = Pattern.compile(regexStr);
    }

    private string parseSegment() {
        string segment = '';
        string delimeter;
        if (tokens[index] instanceof UriTemplateToken.DelimiterToken) {
            UriTemplateToken.DelimiterToken op = (UriTemplateToken.DelimiterToken) tokens[
                index
            ];
            delimeter = op.delimeter;
            if (!moveNext()) {
                //pattern ends in delimeter
                return '\\' + delimeter;
            }
        }

        if (tokens[index] instanceof UriTemplateToken.IdentifierToken) {
            UriTemplateToken.IdentifierToken id = (UriTemplateToken.IdentifierToken) tokens[
                index
            ];
            segment += (delimeter != null ? '\\' + delimeter : '') + id.value;
        } else if (
            tokens[index] instanceof UriTemplateToken.StartNameParamToken
        ) {
            segment += parseNameParam(delimeter);
        } else if (tokens[index] instanceof UriTemplateToken.DelimiterToken) {
            // double //
            segment += '\\' + delimeter;
            index--; //probably a better way?
        }else if(tokens[index] instanceof UriTemplateToken.WildCardParamToken){
            segment = '(' + (delimeter != null ? '?:\\' + delimeter : '') + '([^#\\?]+?))';

            this.captureGroup++;
            namedParameterCaptures.put(this.captureGroup, '*');
            if(peek() != null){
              throw new ParseException('WildCard (*) can only occur at the very end of a template!');
            }
        } else {
            throw new ParseException('Unexpected Token ' + tokens[index]);
        }

        return segment;
    }

    private string parseNameParam(String delimeter) {
        String regex = '';
        if (delimeter == null) {
            delimeter = '\\/';
        }
        if (moveNext()) {
            if (tokens[index] instanceof UriTemplateToken.IdentifierToken) {
                UriTemplateToken.IdentifierToken id = (UriTemplateToken.IdentifierToken) tokens[
                    index
                ];
                regex += '(?:\\' + delimeter + '([^\\/#\\?]+?))';
                this.captureGroup++;
                namedParameterCaptures.put(this.captureGroup, id.value);
            }
            if (peek() instanceof UriTemplateToken.OptionalNameParamToken) {
                regex += '?';
                moveNext();
            }
            if(peek() instanceof UriTemplateToken.WildCardParamToken){
              regex = '(?:\\' + delimeter + '([^#\\?]+?))';
              moveNext();
            }
            return regex;
        }
        throw new ParseException(
            'Expected to find name segment ' + tokens[index]
        );
    }

    private boolean moveNext() {
        if (index + 1 < tokens.size()) {
            index++;
            return true;
        }
        return false;
    }

    private UriTemplateToken peek() {
        if (index + 1 < tokens.size()) {
            return tokens[index + 1];
        }
        return null;
    }

    public class ParseException extends Exception {
    }
}

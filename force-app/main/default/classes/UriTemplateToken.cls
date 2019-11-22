//Author: charlie@callaway.cloud
//  Description: Tokens classes
//
public abstract class UriTemplateToken {
    public class DelimiterToken extends UriTemplateToken {
        public String delimeter;

        public DelimiterToken(String value) {
            this.delimeter = value;
        }
    }

    public class StartNameParamToken extends UriTemplateToken {
    }

    public class IdentifierToken extends UriTemplateToken {
        public string value;
        public IdentifierToken(String s) {
            value = s;
        }
    }

    public class OptionalNameParamToken extends UriTemplateToken {
    }
}

//Author: charlie@callaway.cloud
//  Description: Because apex doesn't have one :(
//    Should probably be moved to seperate package
//
public class StringReader {
    String[] characters;
    Integer index = 0;
    public StringReader(String s) {
        this.characters = s.split('');
    }

    public String read() {
        String character = characters[index];
        index++;
        return character;
    }

    public String peek() {
        return characters[index];
    }

    public Boolean canRead() {
        return index < characters.size();
    }
}

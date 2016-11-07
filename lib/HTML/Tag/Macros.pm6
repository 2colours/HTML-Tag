use v6;
use HTML::Tag;

class HTML::Tag::Macro::CSS
{
    has Str $.href is required;

    method render() {
	return "<link rel=\"stylesheet\" type=\"text/css\" href=\"$!href\">";
    }
}

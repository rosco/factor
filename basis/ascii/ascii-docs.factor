USING: help.markup help.syntax ;
IN: ascii

HELP: blank?
{ $values { "ch" "a character" } { "?" "a boolean" } }
{ $description "Tests for an ASCII whitespace character." } ;

HELP: letter?
{ $values { "ch" "a character" } { "?" "a boolean" } }
{ $description "Tests for a lowercase alphabet ASCII character." } ;

HELP: LETTER?
{ $values { "ch" "a character" } { "?" "a boolean" } }
{ $description "Tests for a uppercase alphabet ASCII character." } ;

HELP: digit?
{ $values { "ch" "a character" } { "?" "a boolean" } }
{ $description "Tests for an ASCII decimal digit character." } ;

HELP: Letter?
{ $values { "ch" "a character" } { "?" "a boolean" } }
{ $description "Tests for an ASCII alphabet character, both upper and lower case." } ;

HELP: alpha?
{ $values { "ch" "a character" } { "?" "a boolean" } }
{ $description "Tests for an alphanumeric ASCII character." } ;

HELP: printable?
{ $values { "ch" "a character" } { "?" "a boolean" } }
{ $description "Tests for a printable ASCII character." } ;

HELP: control?
{ $values { "ch" "a character" } { "?" "a boolean" } }
{ $description "Tests for an ASCII control character." } ;

HELP: quotable?
{ $values { "ch" "a character" } { "?" "a boolean" } }
{ $description "Tests for characters which may appear in a Factor string literal without escaping." } ;

HELP: ascii?
{ $values { "ch" "a character" } { "?" "a boolean" } }
{ $description "Tests for whether a number is an ASCII character." } ;

HELP: ch>lower
{ $values { "ch" "a character" } { "lower" "a character" } }
{ $description "Converts an ASCII character to lower case." } ;

HELP: ch>upper
{ $values { "ch" "a character" } { "upper" "a character" } }
{ $description "Converts an ASCII character to upper case." } ;

HELP: >lower
{ $values { "str" "a string" } { "lower" "a string" } }
{ $description "Converts an ASCII string to lower case." } ;

HELP: >upper
{ $values { "str" "a string" } { "upper" "a string" } }
{ $description "Converts an ASCII string to upper case." } ;

ARTICLE: "ascii" "ASCII"
"The " { $vocab-link "ascii" } " vocabulary implements support for the legacy ASCII character set. Most applications should use " { $link "unicode" } " instead."
$nl
"ASCII character classes:"
{ $subsection blank? }
{ $subsection letter? }
{ $subsection LETTER? }
{ $subsection digit? }
{ $subsection printable? }
{ $subsection control? }
{ $subsection quotable? }
{ $subsection ascii? }
"ASCII case conversion:"
{ $subsection ch>lower }
{ $subsection ch>upper }
{ $subsection >lower }
{ $subsection >upper } ;

ABOUT: "ascii"

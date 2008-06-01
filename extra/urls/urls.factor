! Copyright (C) 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel unicode.categories combinators sequences splitting
fry namespaces assocs arrays strings mirrors
io.encodings.string io.encodings.utf8
math math.parser accessors namespaces.lib ;
IN: urls

: url-quotable? ( ch -- ? )
    #! In a URL, can this character be used without
    #! URL-encoding?
    {
        { [ dup letter? ] [ t ] }
        { [ dup LETTER? ] [ t ] }
        { [ dup digit? ] [ t ] }
        { [ dup "/_-.:" member? ] [ t ] }
        [ f ]
    } cond nip ; foldable

: push-utf8 ( ch -- )
    1string utf8 encode
    [ CHAR: % , >hex 2 CHAR: 0 pad-left % ] each ;

: url-encode ( str -- str )
    [
        [ dup url-quotable? [ , ] [ push-utf8 ] if ] each
    ] "" make ;

: url-decode-hex ( index str -- )
    2dup length 2 - >= [
        2drop
    ] [
        [ 1+ dup 2 + ] dip subseq  hex> [ , ] when*
    ] if ;

: url-decode-% ( index str -- index str )
    2dup url-decode-hex [ 3 + ] dip ;

: url-decode-+-or-other ( index str ch -- index str )
    dup CHAR: + = [ drop CHAR: \s ] when , [ 1+ ] dip ;

: url-decode-iter ( index str -- )
    2dup length >= [
        2drop
    ] [
        2dup nth dup CHAR: % = [
            drop url-decode-%
        ] [
            url-decode-+-or-other
        ] if url-decode-iter
    ] if ;

: url-decode ( str -- str )
    [ 0 swap url-decode-iter ] "" make utf8 decode ;

: add-query-param ( value key assoc -- )
    [
        at [
            {
                { [ dup string? ] [ swap 2array ] }
                { [ dup array? ] [ swap suffix ] }
                { [ dup not ] [ drop ] }
            } cond
        ] when*
    ] 2keep set-at ;

: query>assoc ( query -- assoc )
    dup [
        "&" split H{ } clone [
            [
                [ "=" split1 [ dup [ url-decode ] when ] bi@ swap ] dip
                add-query-param
            ] curry each
        ] keep
    ] when ;

: assoc>query ( hash -- str )
    [
        {
            { [ dup number? ] [ number>string 1array ] }
            { [ dup string? ] [ 1array ] }
            { [ dup sequence? ] [ ] }
        } cond
    ] assoc-map
    [
        [
            [ url-encode ] dip
            [ url-encode "=" swap 3append , ] with each
        ] assoc-each
    ] { } make "&" join ;

TUPLE: url protocol host port path query anchor ;

: query-param ( request key -- value )
    swap query>> at ;

: set-query-param ( request value key -- request )
    pick query>> set-at ;

: parse-host ( string -- host port )
    ":" split1 [ url-decode ] [
        dup [
            string>number
            dup [ "Invalid port" throw ] unless
        ] when
    ] bi* ;

: parse-host-part ( protocol rest -- string' )
    [ "protocol" set ] [
        "//" ?head [ "Invalid URL" throw ] unless
        "/" split1 [
            parse-host [ "host" set ] [ "port" set ] bi*
        ] [ "/" prepend ] bi*
    ] bi* ;

: string>url ( string -- url )
    [
        ":" split1 [ parse-host-part ] when*
        "#" split1 [
            "?" split1 [ query>assoc "query" set ] when*
            url-decode "path" set
        ] [
            url-decode "anchor" set
        ] bi*
    ] url make-object ;

: unparse-host-part ( protocol -- )
    %
    "://" %
    "host" get url-encode %
    "port" get [ ":" % # ] when*
    "path" get "/" head? [ "Invalid URL" throw ] unless ;

: url>string ( url -- string )
    [
        <mirror> [
            "protocol" get [ unparse-host-part ] when*
            "path" get url-encode %
            "query" get [ "?" % assoc>query % ] when*
            "anchor" get [ "#" % url-encode % ] when*
        ] bind
    ] "" make ;

: url-append-path ( path1 path2 -- path )
    {
        { [ dup "/" head? ] [ nip ] }
        { [ dup empty? ] [ drop ] }
        { [ over "/" tail? ] [ append ] }
        { [ "/" pick start not ] [ nip ] }
        [ [ "/" last-split1 drop "/" ] dip 3append ]
    } cond ;

: derive-url ( base url -- url' )
    [ clone dup ] dip
    2dup [ path>> ] bi@ url-append-path
    [ [ <mirror> ] bi@ [ nip ] assoc-filter update ] dip
    >>path ;

: relative-url ( url -- url' )
    clone f >>protocol f >>host f >>port ;
! Copyright (C) 2008, 2009 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors alien alien.c-types assocs byte-arrays classes
compiler.units functors io kernel lexer libc math
math.vectors.specialization namespaces parser
prettyprint.custom sequences sequences.private strings summary
vocabs vocabs.loader vocabs.parser words ;
IN: specialized-arrays

MIXIN: specialized-array

INSTANCE: specialized-array sequence

GENERIC: direct-array-syntax ( obj -- word )

ERROR: bad-byte-array-length byte-array type ;

M: bad-byte-array-length summary
    drop "Byte array length doesn't divide type width" ;

: (underlying) ( n c-type -- array )
    heap-size * (byte-array) ; inline

: <underlying> ( n type -- array )
    heap-size * <byte-array> ; inline

<PRIVATE

FUNCTOR: define-array ( T -- )

A            DEFINES-CLASS ${T}-array
S            DEFINES-CLASS ${T}-sequence
<A>          DEFINES <${A}>
(A)          DEFINES (${A})
<direct-A>   DEFINES <direct-${A}>
malloc-A     DEFINES malloc-${A}
>A           DEFINES >${A}
byte-array>A DEFINES byte-array>${A}

A{           DEFINES ${A}{
A@           DEFINES ${A}@

NTH          [ T dup c-type-getter-boxer array-accessor ]
SET-NTH      [ T dup c-setter array-accessor ]

WHERE

MIXIN: S

TUPLE: A
{ underlying c-ptr read-only }
{ length array-capacity read-only } ;

: <direct-A> ( alien len -- specialized-array ) A boa ; inline

: <A> ( n -- specialized-array ) [ T <underlying> ] keep <direct-A> ; inline

: (A) ( n -- specialized-array ) [ T (underlying) ] keep <direct-A> ; inline

: malloc-A ( len -- specialized-array ) [ T heap-size calloc ] keep <direct-A> ; inline

: byte-array>A ( byte-array -- specialized-array )
    dup length T heap-size /mod 0 = [ drop T bad-byte-array-length ] unless
    <direct-A> ; inline

M: A clone [ underlying>> clone ] [ length>> ] bi <direct-A> ; inline

M: A length length>> ; inline

M: A nth-unsafe underlying>> NTH call ; inline

M: A set-nth-unsafe underlying>> SET-NTH call ; inline

: >A ( seq -- specialized-array ) A new clone-like ;

M: A like drop dup A instance? [ >A ] unless ; inline

M: A new-sequence drop (A) ; inline

M: A equal? over A instance? [ sequence= ] [ 2drop f ] if ;

M: A resize
    [
        [ T heap-size * ] [ underlying>> ] bi*
        resize-byte-array
    ] [ drop ] 2bi
    <direct-A> ; inline

M: A byte-length underlying>> length ; inline
M: A pprint-delims drop \ A{ \ } ;
M: A >pprint-sequence ;

SYNTAX: A{ \ } [ >A ] parse-literal ;
SYNTAX: A@ scan-object scan-object <direct-A> parsed ;

INSTANCE: A specialized-array

A T c-type-boxed-class f specialize-vector-words

;FUNCTOR

: underlying-type ( c-type -- c-type' )
    dup c-types get at string? [
        c-types get at underlying-type
    ] when ;

: specialized-array-vocab ( c-type -- vocab )
    "specialized-arrays.instances." prepend ;

: defining-array-message ( type -- )
    "quiet" get [ drop ] [
        "Generating specialized " " arrays..." surround print
    ] if ;

PRIVATE>

: define-array-vocab ( type  -- vocab )
    underlying-type
    dup specialized-array-vocab vocab
    [ ] [
        [ defining-array-message ]
        [
            [
                dup specialized-array-vocab
                [ define-array ] with-current-vocab
            ] with-compilation-unit
        ]
        [ specialized-array-vocab ]
        tri
    ] ?if ;

M: string require-c-array define-array-vocab drop ;

ERROR: specialized-array-vocab-not-loaded c-type ;

M: string c-array-constructor
    underlying-type
    dup [ "<" "-array>" surround ] [ specialized-array-vocab ] bi lookup
    [ ] [ specialized-array-vocab-not-loaded ] ?if ; foldable

M: string c-(array)-constructor
    underlying-type
    dup [ "(" "-array)" surround ] [ specialized-array-vocab ] bi lookup
    [ ] [ specialized-array-vocab-not-loaded ] ?if ; foldable

M: string c-direct-array-constructor
    underlying-type
    dup [ "<direct-" "-array>" surround ] [ specialized-array-vocab ] bi lookup
    [ ] [ specialized-array-vocab-not-loaded ] ?if ; foldable

SYNTAX: SPECIALIZED-ARRAY:
    scan define-array-vocab use-vocab ;

"prettyprint" vocab [
    "specialized-arrays.prettyprint" require
] when

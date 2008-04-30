! Copyright (C) 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences accessors namespaces combinators
locals db.tuples
http.server.templating.chloe
http.server.boilerplate
http.server.auth.providers
http.server.auth.providers.db
http.server.auth.login
http.server.forms
http.server.components.inspector
http.server.components
http.server.validators
http.server.sessions
http.server.actions
http.server.crud
http.server ;
IN: http.server.auth.admin

: admin-template ( name -- template )
    "resource:extra/http/server/auth/admin/" swap ".xml" 3append <chloe> ;

: <new-user-form> ( -- form )
    "user" <form>
        "new-user" admin-template >>edit-template
        "username" <string> add-field
        "realname" <string> add-field
        "new-password" <password> t >>required add-field
        "verify-password" <password> t >>required add-field
        "email" <email> add-field ;

: <edit-user-form> ( -- form )
    "user" <form>
        "edit-user" admin-template >>edit-template
        "user-summary" admin-template >>summary-template
        "username" <string> hidden >>renderer add-field
        "realname" <string> add-field
        "new-password" <password> add-field
        "verify-password" <password> add-field
        "email" <email> add-field
        "profile" <inspector> add-field ;

: <user-list-form> ( -- form )
    "user-list" <form>
        "user-list" admin-template >>view-template
        "list" <edit-user-form> +unordered+ <list> add-field ;

:: <new-user-action> ( form ctor next -- action )
    <action>
        [
            blank-values

            "username" get ctor call

            {
                [ username>> "username" set-value ]
                [ realname>> "realname" set-value ]
                [ email>> "email" set-value ]
                [ profile>> "profile" set-value ]
            } cleave
        ] >>init

        [ form edit-form ] >>display

        [
            blank-values

            form validate-form

            same-password-twice

            user new "username" value >>username select-tuple [
                user-exists? on
                validation-failed
            ] when

            "username" value <user>
                "realname" value >>realname
                "email" value >>email
                "new-password" value >>password
                H{ } clone >>profile

            insert-tuple

            next f <standard-redirect>
        ] >>submit ;
    
:: <edit-user-action> ( form ctor next -- action )
    <action>
        { { "username" [ v-required ] } } >>get-params

        [
            blank-values

            "username" get ctor call select-tuple

            {
                [ username>> "username" set-value ]
                [ realname>> "realname" set-value ]
                [ email>> "email" set-value ]
                [ profile>> "profile" set-value ]
            } cleave
        ] >>init

        [ form edit-form ] >>display

        [
            blank-values

            form validate-form

            "username" value <user> select-tuple
                "realname" value >>realname
                "email" value >>email

            { "new-password" "verify-password" }
            [ value empty? ] all? [
                same-password-twice
                "new-password" value >>password
            ] unless

            update-tuple

            next f <standard-redirect>
        ] >>submit ;

:: <delete-user-action> ( ctor next -- action )
    <action>
        { { "username" [ ] } } >>post-params

        [
            "username" get
            [ <user> select-tuple 1 >>deleted update-tuple ]
            [ logout-all-sessions ]
            bi

            next f <standard-redirect>
        ] >>submit ;

TUPLE: user-admin < dispatcher ;

:: <user-admin> ( -- responder )
    [let | ctor [ [ <user> ] ] |
        user-admin new-dispatcher
            <user-list-form> ctor <list-action> "" add-responder
            <new-user-form> ctor "$user-admin" <new-user-action> "new" add-responder
            <edit-user-form> ctor "$user-admin" <edit-user-action> "edit" add-responder
            ctor "$user-admin" <delete-user-action> "delete" add-responder
        <boilerplate>
            "admin" admin-template >>template
        <protected>
    ] ;
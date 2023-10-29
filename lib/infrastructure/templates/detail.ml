open Base

let render (contact : Models.Contact.t) request =
  let open Tyxml.Html in
  let component =
    [ h1 [ txt (Printf.sprintf "%s %s" contact.first contact.last) ]
    ; div
        [ div [ txt @@ Printf.sprintf "Phone: %s" contact.phone ]
        ; div [ txt @@ Printf.sprintf "Email: %s" contact.email ]
        ]
    ; p
        ~a:[ a_class [ "f-row" ] ]
        [ a
            ~a:
              [ a_href
                @@ Printf.sprintf "/contacts/%i/edit"
                @@ Option.value_exn contact.id
              ]
            [ txt "Edit" ]
        ; a ~a:[ a_href "/contacts" ] [ txt "Back" ]
        ]
    ]
  in
  Layout.render request component
;;

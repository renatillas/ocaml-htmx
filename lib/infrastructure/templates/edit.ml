open Base

let render ?(messages = []) (contact : Dom.Contact.t) request =
  let contact_id = Option.value_exn contact.id in
  let open Tyxml.Html in
  let component =
    [ form
        ~a:[ a_action (Printf.sprintf "/contacts/%i/edit" contact_id); a_method `Post ]
        [ Unsafe.data (Dream.csrf_tag request)
        ; fieldset
            ~legend:(legend [ txt "Contact values" ])
            [ p
                [ label ~a:[ a_label_for "email" ] [ txt "Email" ]
                ; input
                    ~a:
                      [ a_name "email"
                      ; a_id "email"
                      ; a_input_type `Email
                      ; a_placeholder "Email"
                      ; a_value contact.Dom.Contact.email
                      ]
                    ()
                ]
            ; p
                [ label ~a:[ a_label_for "first_name" ] [ txt "First Name" ]
                ; input
                    ~a:
                      [ a_name "first_name"
                      ; a_id "first_name"
                      ; a_input_type `Text
                      ; a_placeholder "First name"
                      ; a_value contact.first
                      ]
                    ()
                ]
            ; p
                [ label ~a:[ a_label_for "last_name" ] [ txt "Last Name" ]
                ; input
                    ~a:
                      [ a_name "last_name"
                      ; a_id "last_name"
                      ; a_input_type `Text
                      ; a_placeholder "Last Name"
                      ; a_value contact.last
                      ]
                    ()
                ]
            ; p
                [ label ~a:[ a_label_for "phone" ] [ txt "Phone" ]
                ; input
                    ~a:
                      [ a_name "phone"
                      ; a_id "phone"
                      ; a_input_type `Text
                      ; a_placeholder "Phone"
                      ; a_value contact.phone
                      ]
                    ()
                ]
            ; button [ txt "Save" ]
            ]
        ]
    ; form
        ~a:[ a_action @@ Printf.sprintf "/contacts/%i/delete" contact_id; a_method `Post ]
        [ Unsafe.data (Dream.csrf_tag request)
          (* This is necessary for dream's csrf things *)
        ; button [ txt "Delete contact" ]
        ]
    ; p [ a ~a:[ a_href @@ Printf.sprintf "/contacts/%i" contact_id ] [ txt "Back" ] ]
    ]
  in
  Layout.render ~messages request component
;;

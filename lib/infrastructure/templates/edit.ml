open Base

let render
  ?(messages = [])
  ?(errors : Validators.Contact_validator.t option)
  ~(contact : Models.Contact.t)
  request
  =
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
                      ; a_value contact.email
                      ]
                    ()
                ; span
                    ~a:[ a_class [ "color"; "bad" ] ]
                    [ txt Option.(value ~default:"" (errors >>= fun err -> err.email)) ]
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
                ; span
                    ~a:[ a_class [ "color"; "bad" ] ]
                    [ txt Option.(value ~default:"" (errors >>= fun err -> err.first)) ]
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
                ; span
                    ~a:[ a_class [ "color"; "bad" ] ]
                    [ txt Option.(value ~default:"" (errors >>= fun err -> err.last)) ]
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
                ; span
                    ~a:[ a_class [ "color"; "bad" ] ]
                    [ txt Option.(value ~default:"" (errors >>= fun err -> err.phone)) ]
                ]
            ; button [ txt "Save" ]
            ]
        ]
    ; button
        ~a:
          [ Unsafe.string_attrib "hx-delete" (Printf.sprintf "/contacts/%i" contact_id)
          ; Unsafe.string_attrib "hx-target" "body"
          ; Unsafe.string_attrib "hx-push-url" "true"
          ; Unsafe.string_attrib
              "hx-confirm"
              "Are you sure you want to delete this contact?"
          ]
        [ txt "Delete contact" ]
    ; p [ a ~a:[ a_href (Printf.sprintf "/contacts/%i" contact_id) ] [ txt "Back" ] ]
    ]
  in
  Layout.render ~messages request component
;;

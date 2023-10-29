open Base

let render
  ?(messages = [])
  ?(contact : Models.Contact.t option)
  ?(errors : Validators.Contact_validator.t option)
  request
  =
  let open Tyxml.Html in
  let component =
    [ form
        ~a:[ a_action "/contacts/new"; a_method `Post ]
        [ Unsafe.data (Dream.csrf_tag request)
        ; fieldset
            ?legend:(Some (legend [ txt "Contact values" ]))
            [ div
                ~a:[ a_class [ "table"; "rows" ] ]
                [ p
                    [ label ~a:[ a_label_for "email" ] [ txt "Email" ]
                    ; input
                        ~a:
                          [ a_name "email"
                          ; a_id "email"
                          ; a_input_type `Email
                          ; a_placeholder "Email"
                          ; a_value
                              (Option.value_map contact ~default:"" ~f:(fun c -> c.email))
                          ]
                        ()
                    ; span
                        ~a:[ a_class [ "color"; "bad" ] ]
                        [ txt Option.(value ~default:"" (errors >>= fun err -> err.email))
                        ]
                    ]
                ; p
                    [ label ~a:[ a_label_for "first_name" ] [ txt "First Name" ]
                    ; input
                        ~a:
                          [ a_name "first_name"
                          ; a_id "first_name"
                          ; a_input_type `Text
                          ; a_placeholder "First name"
                          ; a_value
                              (Option.value_map contact ~default:"" ~f:(fun c -> c.first))
                          ]
                        ()
                    ; span
                        ~a:[ a_class [ "color"; "bad" ] ]
                        [ txt Option.(value ~default:"" (errors >>= fun err -> err.first))
                        ]
                    ]
                ; p
                    [ label ~a:[ a_label_for "last_name" ] [ txt "Last Name" ]
                    ; input
                        ~a:
                          [ a_name "last_name"
                          ; a_id "last_name"
                          ; a_input_type `Text
                          ; a_placeholder "Last Name"
                          ; a_value
                              (Option.value_map contact ~default:"" ~f:(fun c -> c.last))
                          ]
                        ()
                    ; span
                        ~a:[ a_class [ "color"; "bad" ] ]
                        [ txt Option.(value ~default:"" (errors >>= fun err -> err.last))
                        ]
                    ]
                ; p
                    [ label ~a:[ a_label_for "phone" ] [ txt "Phone" ]
                    ; input
                        ~a:
                          [ a_name "phone"
                          ; a_id "phone"
                          ; a_input_type `Text
                          ; a_placeholder "Phone"
                          ; a_value
                              (Option.value_map contact ~default:"" ~f:(fun c -> c.phone))
                          ]
                        ()
                    ; span
                        ~a:[ a_class [ "color"; "bad" ] ]
                        [ txt Option.(value ~default:"" (errors >>= fun err -> err.phone))
                        ]
                    ]
                ; button [ txt "Save" ]
                ]
            ]
        ]
    ; p [ a ~a:[ a_href "/contacts" ] [ txt "Back" ] ]
    ]
  in
  Layout.render ~messages request component
;;

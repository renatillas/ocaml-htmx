let render ?(messages = []) ?email ?first ?last ?phone request =
  let open Tyxml.Html in
  let component =
    [ form
        ~a:[ a_action "/contacts/new"; a_method `Post ]
        [ Unsafe.data (Dream.csrf_tag request)
        ; fieldset
            ?legend:(Some (legend [ txt "Contact values" ]))
            [ p
                [ label ~a:[ a_label_for "email" ] [ txt "Email" ]
                ; input
                    ~a:
                      [ a_name "email"
                      ; a_id "email"
                      ; a_input_type `Email
                      ; a_placeholder "Email"
                      ; a_value (Option.value email ~default:"")
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
                      ; a_value (Option.value first ~default:"")
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
                      ; a_value (Option.value last ~default:"")
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
                      ; a_value (Option.value phone ~default:"")
                      ]
                    ()
                ]
            ; button [ txt "Save" ]
            ]
        ]
    ; p [ a ~a:[ a_href "/contacts" ] [ txt "Back" ] ]
    ]
  in
  Layout.render ~messages request component
;;

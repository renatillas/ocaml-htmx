open Base

let render default contacts request =
  let open Tyxml.Html in
  let component default_search_value _contacts =
    let search_term_form =
      form
        ~a:[ a_action "/contacts"; a_method `Get; a_class [ "tool-bar" ] ]
        [ label ~a:[ a_label_for "search" ] [ txt "Search term" ]
        ; input
            ~a:
              [ a_id "search"
              ; a_input_type `Search
              ; a_value default_search_value
              ; a_name "q"
              ]
            ()
        ; input ~a:[ a_input_type `Submit; a_value "Search" ] ()
        ]
    in
    let row_contact (contact : Models.Contact.t) =
      tr
        [ td [ txt contact.first ]
        ; td [ txt contact.last ]
        ; td [ txt contact.phone ]
        ; td [ txt contact.email ]
        ; td
            [ a
                ~a:
                  [ a_href
                    @@ Printf.sprintf "/contacts/%i/edit" (Option.value_exn contact.id)
                  ]
                [ txt "Edit" ]
            ]
        ; td
            [ a
                ~a:
                  [ a_href @@ Printf.sprintf "/contacts/%i" (Option.value_exn contact.id)
                  ]
                [ txt "View" ]
            ]
        ]
    in
    let table_header =
      thead
        [ tr
            [ th [ txt "First" ]
            ; th [ txt "Last" ]
            ; th [ txt "Phone" ]
            ; th [ txt "Email" ]
            ]
        ]
    in
    let table =
      table ~thead:table_header (Set.to_list _contacts |> List.map ~f:row_contact)
    in
    let add_contact_button =
      p [ a ~a:[ a_href "/contacts/new" ] [ txt "Add Contact" ] ]
    in
    [ div
        ~a:[ a_class [ "box"; "plain"; "flow-gap" ] ]
        [ search_term_form; table; add_contact_button ]
    ]
  in
  Layout.render request (component default contacts)
;;

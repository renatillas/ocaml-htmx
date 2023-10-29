open Base

let generate_flash_block ~messages ~request ~category ~colorway ~titlebar =
  let all_messages = messages @ Dream.flash_messages request in
  let filtered_messages =
    List.filter ~f:(fun (c, _) -> String.equal c category) all_messages
  in
  let div_template messages =
    Tyxml.Html.(
      div
        ~a:[ a_class [ "box"; colorway ] ]
        ([ strong ~a:[ a_class [ "block"; "titlebar" ] ] [ txt titlebar ] ] @ messages))
  in
  let message_to_p (_, text) = Tyxml.Html.(p [ txt text ]) in
  match filtered_messages with
  | [] -> []
  | messages -> [ div_template (List.map ~f:message_to_p messages) ]
;;

let render ?(messages = []) request contents =
  let layout _contents =
    Tyxml.Html.(
      html
        (head
           (title (txt "Contact app"))
           [ link ~rel:[ `Stylesheet ] ~href:"https://unpkg.com/missing.css@1.1.1" () ])
        (body
           [ main
               ([ header
                    [ h1 ~a:[ a_class [ "allcaps" ] ] [ txt "contacts.app" ]
                    ; h2
                        ~a:[ a_class [ "sub-title" ] ]
                        [ txt "A Demo Contacts Application" ]
                    ]
                ]
                @ generate_flash_block
                    ~messages
                    ~request
                    ~category:"Info"
                    ~colorway:"info"
                    ~titlebar:"Info"
                @ generate_flash_block
                    ~messages
                    ~request
                    ~category:"Success"
                    ~colorway:"ok"
                    ~titlebar:"Success"
                @ generate_flash_block
                    ~messages
                    ~request
                    ~category:"Warn"
                    ~colorway:"warn"
                    ~titlebar:"Warning"
                @ generate_flash_block
                    ~messages
                    ~request
                    ~category:"Error"
                    ~colorway:"bad"
                    ~titlebar:"Error"
                @ _contents)
           ]))
  in
  Stdlib.Format.asprintf "%a" (Tyxml.Html.pp ()) (layout contents)
;;

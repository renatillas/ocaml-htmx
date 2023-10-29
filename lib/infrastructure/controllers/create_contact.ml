let get request = Templates.New.render request |> Dream.html

let post request =
  match%lwt Dream.form request with
  | `Ok [ ("email", email); ("first_name", first); ("last_name", last); ("phone", phone) ]
    ->
    Lwt.try_bind
      (fun () ->
        Repositories.ContactRepository.save
          request
          { Dom.Contact.id = None; email; first; last; phone })
      (fun _ ->
        Dream.add_flash_message request "Info" "Contact created!";
        Dream.redirect request "/contacts")
      (fun _ ->
        let messages =
          [ ( "Warn"
            , "Contact could not be created. There's another contact with that email." )
          ]
        in
        Templates.New.render ~messages ~email ~first ~last ~phone request |> Dream.html)
  | _ ->
    Dream.add_flash_message request "Error" "There was an error with your form.";
    Dream.redirect request "/contacts"
;;

let get request = Templates.New.render request |> Dream.html

let post request =
  match%lwt Dream.form request with
  | `Ok [ ("email", email); ("first_name", first); ("last_name", last); ("phone", phone) ]
    ->
    let new_contact : Models.Contact.t = { id = None; email; first; last; phone } in
    let%lwt errors, has_errors =
      Validators.Contact_validator.validate request new_contact
    in
    (match has_errors with
     | false ->
       let%lwt _ = Repositories.ContactRepository.save request ~contact:new_contact in
       Dream.add_flash_message request "Success" "Contact created!";
       Dream.redirect request "/contacts"
     | true ->
       let messages = [ "Warn", "Some errors were detected validating the data" ] in
       Templates.New.render ~messages ~contact:new_contact ~errors request |> Dream.html)
  | _ ->
    Dream.add_flash_message request "Error" "There was an error with your form.";
    Dream.redirect request "/contacts"
;;

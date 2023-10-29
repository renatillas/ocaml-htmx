open Base

let get request =
  let id = Int.of_string (Dream.param request "id") in
  let%lwt contact = Repositories.ContactRepository.find_by_id request ~id in
  Templates.Edit.render ~contact request |> Dream.html
;;

let post request =
  let id = Int.of_string (Dream.param request "id") in
  match%lwt Dream.form request with
  | `Ok [ ("email", email); ("first_name", first); ("last_name", last); ("phone", phone) ]
    ->
    let contact : Models.Contact.t = { id = Some id; email; first; last; phone } in
    let%lwt errors, has_errors = Validators.Contact_validator.validate request contact in
    (match has_errors with
     | false ->
       let%lwt () = Repositories.ContactRepository.update request ~contact in
       Dream.add_flash_message request "Info" "Contact updated!";
       Dream.redirect request @@ Printf.sprintf "/contacts/%i" id
     | true ->
       let messages = [ "Warn", "Some errors were detected validating the data" ] in
       Templates.Edit.render ~messages ~contact ~errors request |> Dream.html)
  | _ ->
    Dream.add_flash_message request "Error" "There was an error with your form.";
    Dream.redirect request "/contacts"
;;

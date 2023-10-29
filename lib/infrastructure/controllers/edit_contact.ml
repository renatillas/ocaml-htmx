open Base

let get request =
  let path_param_id = Dream.param request "id" in
  let%lwt contact = Repositories.ContactRepository.find_by_id request ~id:path_param_id in
  Templates.Edit.render contact request |> Dream.html
;;

let post request =
  let path_param_id = Dream.param request "id" in
  match%lwt Dream.form request with
  | `Ok [ ("email", email); ("first_name", first); ("last_name", last); ("phone", phone) ]
    ->
    Lwt.try_bind
      (fun () ->
        let%lwt contact =
          Repositories.ContactRepository.find_by_id request ~id:path_param_id
        in
        Repositories.ContactRepository.update
          request
          ~contact:{ id = contact.id; email; first; last; phone })
      (fun _ ->
        Dream.add_flash_message request "Info" "Contact updated!";
        Dream.redirect request @@ Printf.sprintf "/contacts/%s" path_param_id)
      (fun _ ->
        let messages =
          [ ( "Warn"
            , "Contact could not be updated. There's another contact with that email." )
          ]
        in
        let contact_with_errors =
          { Models.Contact.id = Some (Int.of_string path_param_id)
          ; email
          ; first
          ; last
          ; phone
          }
        in
        Templates.Edit.render ~messages contact_with_errors request |> Dream.html)
  | _ ->
    Dream.add_flash_message request "Error" "There was an error with your form.";
    Dream.redirect request "/contacts"
;;

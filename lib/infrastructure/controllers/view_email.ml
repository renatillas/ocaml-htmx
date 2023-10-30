open Base

let get request =
  let id = Int.of_string @@ Dream.param request "id" in
  let email = Option.value_exn @@ Dream.query request "email" in
  let%lwt contact = Repositories.ContactRepository.find_by_id request ~id in
  let%lwt errors, _ =
    Validators.Contact_validator.validate request { contact with email }
  in
  let email_error = Option.value errors.email ~default:"" in
  Dream.html email_error
;;

open Base

type t =
  { first : string option
  ; last : string option
  ; phone : string option
  ; email : string option
  }

let empty_contact_errors () = { first = None; last = None; phone = None; email = None }

let validate_email request email errors =
  let%lwt contacts_with_same_email =
    Repositories.ContactRepository.find_like request ~filter:email
  in
  if Set.is_empty contacts_with_same_email
  then Lwt.return errors
  else Lwt.return { errors with email = Some "Email must be unique." }
;;

let has_errors (errors : t) =
  match errors with
  | { first = None; last = None; phone = None; email = None } -> false
  | _ -> true
;;

let validate request (contact : Models.Contact.t) =
  let contact_errors = empty_contact_errors () in
  let%lwt contact_errors = validate_email request contact.email contact_errors in
  Lwt.return (contact_errors, has_errors contact_errors)
;;

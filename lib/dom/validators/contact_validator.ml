open Base

type t =
  { first : string option
  ; last : string option
  ; phone : string option
  ; email : string option
  }

let empty_contact_errors () = { first = None; last = None; phone = None; email = None }

let validate_email request (contact : Models.Contact.t) errors =
  match%lwt Repositories.ContactRepository.find_by_email request ~email:contact.email with
  | Some { id; _ } when not (Option.equal (fun id1 id2 -> id1 = id2) id contact.id) ->
    Lwt.return { errors with email = Some "Email must be unique." }
  | _ -> Lwt.return errors
;;

let has_errors (errors : t) =
  match errors with
  | { first = None; last = None; phone = None; email = None } -> false
  | _ -> true
;;

let validate request (contact : Models.Contact.t) =
  let contact_errors = empty_contact_errors () in
  let%lwt contact_errors = validate_email request contact contact_errors in
  Lwt.return (contact_errors, has_errors contact_errors)
;;

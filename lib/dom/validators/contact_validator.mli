type t =
  { first : string option
  ; last : string option
  ; phone : string option
  ; email : string option
  }

val empty_contact_errors : unit -> t
val validate : Dream.request -> Models.Contact.t -> (t * bool) Lwt.t

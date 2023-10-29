open Base

let ( let* ) = Lwt.bind

module Query = struct
  open Caqti_request.Infix

  let contact_type = Caqti_type.(tup2 int (tup4 string string string string))

  let count = Caqti_type.(unit ->! int) {| 
        SELECT COUNT * FROM contacts|}

  let ls =
    Caqti_type.(unit ->* contact_type)
      {| 
        SELECT id, email, first_name, last_name, phone
        FROM contact|}
  ;;

  let find_like =
    Caqti_type.(string ->* contact_type)
      {|SELECT id, email, first, last, phone 
        FROM contact
        WHERE first like $1 OR last like $1 OR email like $1 OR phone like $1|}
  ;;

  let find_by_id =
    Caqti_type.(string ->! contact_type)
      {|SELECT id, email, first, last, phone 
        FROM contact
        WHERE id = $1|}
  ;;

  let save =
    Caqti_type.(tup4 string string string string ->! contact_type)
      {|INSERT INTO contact (email, first, last, phone)
        VALUES (?, ?, ?, ?)
        RETURNING id, email, first, last, phone|}
  ;;

  let update =
    Caqti_type.(contact_type ->. unit)
      {|UPDATE contact 
        SET email = $2, first = $3, last = $4, phone = $5
        WHERE id = $1
        |}
  ;;

  let delete =
    Caqti_type.(int ->. unit)
      {|
        DELETE FROM contact 
        WHERE id = $1
        |}
  ;;
end

let save request contact =
  let save (module DbConnection : Caqti_lwt.CONNECTION) =
    let* new_contact =
      DbConnection.find
        Query.save
        (contact.Dom.Contact.email, contact.first, contact.last, contact.phone)
    in
    let* new_contact = Caqti_lwt.or_fail new_contact in
    let id, (email, first, last, phone) = new_contact in
    Lwt.return { Dom.Contact.id = Some id; email; first; last; phone }
  in
  Dream.sql request save
;;

let find_like request ~filter =
  let like_filter = Printf.sprintf "%%%s%%" filter in
  let find (module Db : Caqti_lwt.CONNECTION) =
    let* raw_contacts = Db.collect_list Query.find_like like_filter in
    let* raw_contacts = Caqti_lwt.or_fail raw_contacts in
    let contacts =
      List.fold
        ~init:(Set.empty (module Dom.Contact))
        ~f:(fun acc (id, (email, first, last, phone)) ->
          Set.add acc { Dom.Contact.id = Some id; email; first; last; phone })
        raw_contacts
    in
    Lwt.return contacts
  in
  Dream.sql request find
;;

let ls request =
  let ls (module DbConnection : Caqti_lwt.CONNECTION) =
    let* raw_contacts = DbConnection.collect_list Query.ls () in
    let* raw_contacts = Caqti_lwt.or_fail raw_contacts in
    let contacts =
      List.fold
        ~init:(Set.empty (module Dom.Contact))
        ~f:(fun acc (id, (email, first, last, phone)) ->
          Set.add acc { Dom.Contact.id = Some id; email; first; last; phone })
        raw_contacts
    in
    Lwt.return contacts
  in
  Dream.sql request ls
;;

let find_by_id request ~id =
  let find_by_id (module DbConnection : Caqti_lwt.CONNECTION) =
    let* raw_contact = DbConnection.find Query.find_by_id id in
    let* id, (email, first, last, phone) = Caqti_lwt.or_fail raw_contact in
    let contact = { Dom.Contact.id = Some id; email; first; last; phone } in
    Lwt.return contact
  in
  Dream.sql request find_by_id
;;

let update request ~(contact : Dom.Contact.t) =
  let update (module DbConnection : Caqti_lwt.CONNECTION) =
    let* query_result =
      DbConnection.exec
        Query.update
        ( Option.value_exn contact.id
        , (contact.email, contact.first, contact.last, contact.phone) )
    in
    Caqti_lwt.or_fail query_result
  in
  Dream.sql request update
;;

let delete_by_id request ~id =
  let delete_by_id (module DbConnection : Caqti_lwt.CONNECTION) =
    let* query_result = DbConnection.exec Query.delete id in
    Caqti_lwt.or_fail query_result
  in
  Dream.sql request delete_by_id
;;

open Lwt_result.Syntax

module Query = struct
  open Caqti_request.Infix

  let create_table_dream_session =
    Caqti_type.(unit ->. unit)
      {|
        CREATE TABLE dream_session (
          id          TEXT PRIMARY KEY,
          label       TEXT NOT NULL,
          expires_at  REAL NOT NULL,
          payload     TEXT NOT NULL
        )
    |}
  ;;

  let create_table_contact =
    Caqti_type.(unit ->. unit)
      {|
        CREATE TABLE contact (
          id     INTEGER PRIMARY KEY AUTOINCREMENT,
          email  TEXT NOT NULL UNIQUE,
          first  TEXT NOT NULL,
          last   TEXT NOT NULL,
          phone  TEXT NOT NULL
        )
    |}
  ;;

  let drop_table_dream_session =
    Caqti_type.(unit ->. unit) {|
        DROP TABLE dream_session
    |}
  ;;

  let drop_table_contact = Caqti_type.(unit ->. unit) {|
        DROP TABLE contact
    |}
end

let create_tables (module DbConnection : Caqti_lwt.CONNECTION) =
  let* () = DbConnection.start () in
  let* () = DbConnection.exec Query.create_table_contact () in
  let* () = DbConnection.exec Query.create_table_dream_session () in
  let* () = DbConnection.commit () in
  Lwt.return_ok ()
;;

let delete_tables (module DbConnection : Caqti_lwt.CONNECTION) =
  let* () = DbConnection.start () in
  let* () = DbConnection.exec Query.drop_table_contact () in
  let* () = DbConnection.exec Query.drop_table_dream_session () in
  let* () = DbConnection.commit () in
  Lwt.return_ok ()
;;

let connect_exn () =
  let connection_promise = Caqti_lwt.connect (Uri.of_string "sqlite3:db/db.sqlite") in
  match Lwt_main.run connection_promise with
  | Error err ->
    let msg =
      Printf.sprintf
        "Abort! We could not get a connection. (err=%s)\n"
        (Caqti_error.show err)
    in
    failwith msg
  | Ok module_ -> module_
;;

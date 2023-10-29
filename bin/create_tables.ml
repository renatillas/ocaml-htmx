let () =
  let db_connection = Init.connect_exn () in
  match Lwt_main.run (Init.create_tables db_connection) with
  | Error err ->
    let msg =
      Printf.sprintf
        "Abort! We could not get a initialize the tables. (err=%s)\n"
        (Caqti_error.show err)
    in
    failwith msg
  | Ok () -> ()
;;

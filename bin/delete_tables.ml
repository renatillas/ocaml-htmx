let () =
  let _ = Printf.printf "Controller - Starting deleting tables!\n" in
  let db_connection = Init.connect_exn () in
  match Lwt_main.run (Init.delete_tables db_connection) with
  | Error err ->
    Printf.printf
      "Controller - An error happened while deleting the tables:\n%s"
      (Caqti_error.show err)
  | Ok () -> ignore @@ Printf.printf "Controller - Completed successfully!\n"
;;

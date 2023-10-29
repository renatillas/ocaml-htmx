let get request =
  let filter = Option.value (Dream.query request "q") ~default:"" in
  let%lwt contacts = Repositories.ContactRepository.find_like request ~filter in
  Templates.Index.render filter contacts request |> Dream.html
;;

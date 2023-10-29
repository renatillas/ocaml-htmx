let get request =
  let path_param_id = Dream.param request "id" in
  let%lwt contact = Repositories.ContactRepository.find_by_id request ~id:path_param_id in
  Templates.Detail.render contact request |> Dream.html
;;

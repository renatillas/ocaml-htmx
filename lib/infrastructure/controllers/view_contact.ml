open Base

let get request =
  let id = Int.of_string @@ Dream.param request "id" in
  let%lwt contact = Repositories.ContactRepository.find_by_id request ~id in
  Templates.Detail.render contact request |> Dream.html
;;

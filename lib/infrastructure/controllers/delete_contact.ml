open Base

let delete request =
  let path_param_id = Int.of_string (Dream.param request "id") in
  let%lwt () = Repositories.ContactRepository.delete_by_id request ~id:path_param_id in
  Dream.add_flash_message request "Success" "Contact deleted!";
  Dream.redirect ~status:`See_Other request "/contacts"
;;

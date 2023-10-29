open Base

let post request =
  let path_param_id = Int.of_string (Dream.param request "id") in
  let%lwt () = Repositories.ContactRepository.delete_by_id request ~id:path_param_id in
  Dream.add_flash_message request "Info" "Contact deleted!";
  Dream.redirect request "/contacts"
;;

let () =
  Dream.run ~adjust_terminal:false ~greeting:false
  @@ Dream.logger
  @@ Dream.flash
  @@ Dream.sql_pool "sqlite3:/var/lib/ocaml-htmx/db.sqlite"
  @@ Dream.sql_sessions
  @@ Dream.router
       [ Dream.get "/" @@ Controllers.Redirect_contacts.get
       ; Dream.get "/contacts" @@ Controllers.List_contacts.get
       ; Dream.get "/contacts/new" @@ Controllers.Create_contact.get
       ; Dream.post "/contacts/new" @@ Controllers.Create_contact.post
       ; Dream.get "/contacts/:id" @@ Controllers.View_contact.get
       ; Dream.get "/contacts/:id/edit" @@ Controllers.Edit_contact.get
       ; Dream.post "/contacts/:id/edit" @@ Controllers.Edit_contact.post
       ; Dream.post "/contacts/:id/delete" @@ Controllers.Delete_contact.post
       ]
;;

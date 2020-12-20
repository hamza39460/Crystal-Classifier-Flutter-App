enum UserAuthState {
  Uninitialized,
  Authenticated,
  Unauthenticated,
  Login_in_process,
  Error,
  Signup_in_process,
}

enum UserDataState {
  Uninitialized,
  Fetching_User_Data,
  Fetched_User_Data,
  Error,
}

enum WorkspaceState {
  Uninitialized,
  Fetching_All_Workspaces,
  No_Workspace_found,
  ALl_Workspaces_Fetched,
  Error,
}

enum UpdateUserDataStatus { Uninitialized, Updating, Updated, Error }

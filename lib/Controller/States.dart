enum UserAuthState{
  Uninitialized,
  Authenticated,
  Unauthenticated,
  Login_in_process,
  Error,
  Signup_in_process,
}

enum UserDataState{
    Uninitialized,
    Fetching_User_Data,
    Fetched_User_Data,
    Error,
}
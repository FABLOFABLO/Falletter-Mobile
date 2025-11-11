class ApiEndPoints {
  static const baseUrl = "http://3.34.76.83:8080";

  /// User
  static const signUp = "/user/signup";
  static const signIn = "/user/signin";
  static const logOut = "/user/logout";
  static const users = "/user/users";
  static const students = "/user/student";

  /// Auth
  static const emailVerify = "/auth/email/verify";
  static const emailMatch = "/auth/email/match";

  /// Item
  static const letterCount = "/item/letter/count";
  static const letterUpdate = "/item/letter/update";
  static const brickCount = "/item/brick/count";
  static const brickUpdate = "/item/letter/update";

  /// Letter
  static const letterSent = "/letter/sent";

  /// Answer
  static const brickUsed = "/answer/used";

  /// Questions
  static const questions = "/question/all";
}
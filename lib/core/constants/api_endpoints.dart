class ApiEndPoints {
  /// BaseUrl
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

  /// Community
  static const post = "/community/posts";

  /// Comment
  static const comment = "/comment"; // 하는 중

  /// Item
  static const letterCount = "/item/letter/count";
  static const letterUpdate = "/item/letter/update";
  static const brickCount = "/item/brick/count";
  static const brickUpdate = "/item/brick/update"; // 아직

  /// Letter
  static const letterSent = "/letter/sent";
  static const letterSentAll = "/letter/sent/all";

  /// Answer
  static const answerChoose = "/answer/choose"; // 아직
  static const answerChoosen = "/answer/choosen"; // 아직
  static const brickUsed = "/answer/used"; // 아직

  /// Questions
  static const questions = "/question/all"; // 하는중
}
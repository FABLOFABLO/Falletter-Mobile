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
  static const comment = "/comment";

  /// Item
  static const letterCount = "/item/letter/count";
  static const letterUpdate = "/item/letter/update";
  static const brickCount = "/item/brick/count";
  static const brickUpdate = "/item/brick/update";

  /// Letter
  static const letterSent = "/letter/sent";
  static const letterSentAll = "/letter/sent/all";
  static const letterReceived = "/letter/received/all";
  static const letterReceivedDetail = "/letter/received";

  /// history
  static const brickSave = "/history/brick/save"; // 아직
  static const brickUsed = "/history/brick/used"; // 아직

  /// Answer
  static const answerChoose = "/answer/choose";
  static const answerChoosen = "/answer/chosen";

  /// Questions
  static const questions = "/question/all";
}
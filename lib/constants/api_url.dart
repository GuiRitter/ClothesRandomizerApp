enum ApiUrl {
  checkToken(
    path: "user/check",
  ),
  signIn(
    path: "user/sign_in",
  );

  final String path;

  const ApiUrl({
    required this.path,
  });
}

enum ApiUrl {
  checkToken(
    path: "user/check",
  ),
  chunk(
    path: "chunk",
  ),
  signIn(
    path: "user/sign_in",
  );

  final String path;

  const ApiUrl({
    required this.path,
  });
}

enum ApiUrl {
  checkToken(
    path: "user/check",
  ),
  chunk(
    path: "chunk",
  ),
  signIn(
    path: "user/sign_in",
  ),
  uses(
    path: "use/list",
  ),
  incrementUse(
    path: "use/increment",
  ),
  decrementUse(
    path: "use/decrement",
  );

  final String path;

  const ApiUrl({
    required this.path,
  });
}

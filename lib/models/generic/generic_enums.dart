enum WidgetStatus { initial, loading, success, error }

enum AppState { loggedUser, logOut, error }

enum StoragePath {
  profile;

  // Firebase Storage (folder path)
  String toPath() {
    switch (this) {
      case profile:
        return "profileImages";
    }
  }
}

enum AppRouteEnum {
  authPage,
  photoViewPage,
}

extension AppRouteExtension on AppRouteEnum {
  String get name {
    switch (this) {
      case AppRouteEnum.authPage:
        return "/login";

      case AppRouteEnum.photoViewPage:
        return "/photo_view_page";

      default:
        return "/auth_page";
    }
  }
}

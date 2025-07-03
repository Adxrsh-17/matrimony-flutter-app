class GlobalUserCache {
  static Map<String, dynamic>? userData;

  static void clear() {
    userData = null;
  }
}

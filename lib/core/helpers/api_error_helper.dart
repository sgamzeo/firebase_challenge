class ApiErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is String) return error;

    // Handle different error types here
    // This is a generic implementation that can be extended
    return 'An unexpected error occurred';
  }
}

/// A function that represents a form field validator.
/// It takes in a string value and returns a string error message if validation fails,
/// or null if validation passes.
typedef Validator = String? Function(String? value);
// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * An error code associated with an [AnalysisError].
 *
 * Generally, we want to provide messages that consist of three sentences. From
 * the user's perspective these sentences should explain:
 *
 * 1. what is wrong,
 * 2. why is it wrong, and
 * 3. how do I fix it.
 *
 * However, we combine the first two in the [message] and the last in the
 * [correction].
 *
 * When composing messages (including correction messages) keep the following
 * guidelines in mind.
 *
 * 1. The message should be a complete sentence starting with an uppercase
 * letter, and ending with a period.
 *
 * 2. Reserved words and embedded identifiers should be in single quotes, so
 * prefer double quotes for the complete message. For example,
 * ```
 * "The class '{0}' can't use 'super'."
 * ```
 * Notice that the word 'class' in the preceding message is not quoted as it
 * refers to the concept 'class', not the reserved word. On the other hand,
 * 'super' refers to the reserved word. Do not quote 'null' and numeric literals.
 *
 * 3. Do not try to compose messages, as it can make translating them hard.
 *
 * 4. Try to keep the error messages short, but informative.
 *
 * 5. Use simple words and terminology, assume the reader of the message doesn't
 * have an advanced degree in math, and that English is not the reader's native
 * language. Do not assume any formal computer science training. For example, do
 * not use Latin abbreviations (prefer "that is" over "i.e.", and "for example"
 * over "e.g."). Also avoid phrases such as "if and only if" and "iff"; that
 * level of precision is unnecessary.
 *
 * 6. Prefer contractions when they are in common use, for example, prefer
 * "can't" over "cannot". Using "cannot", "must not", "shall not", etc. is
 * off-putting to people new to programming.
 *
 * 7. Use common terminology, preferably from the Dart Language Specification.
 * This increases the user's chance of finding a good explanation on the web.
 *
 * 8. Do not try to be cute or funny. It is extremely frustrating to work on a
 * product that crashes with a "tongue-in-cheek" message, especially if you did
 * not want to use this product to begin with.
 *
 * 9. Do not lie, that is, do not write error messages containing phrases like
 * "can't happen".  If the user ever saw this message, it would be a lie. Prefer
 * messages like: "Internal error: This function should not be called when 'x'
 * is null.".
 *
 * 10. Prefer to not use the imperative tone. That is, the message should not
 * sound accusing or like it is ordering the user around. The computer should
 * describe the problem, not criticize the user for violating the specification.
 */
abstract class ErrorCode {
  /**
   * The name of the error code.
   */
  final String name;

  /**
   * The template used to create the message to be displayed for this error. The
   * message should indicate what is wrong and why it is wrong.
   */
  final String message;

  /**
   * The template used to create the correction to be displayed for this error,
   * or `null` if there is no correction information for this error. The
   * correction should indicate how the user can fix the error.
   */
  final String correction;

  /**
   * Initialize a newly created error code to have the given [name]. The message
   * associated with the error will be created from the given [message]
   * template. The correction associated with the error will be created from the
   * given [correction] template.
   */
  const ErrorCode(this.name, this.message, [this.correction]);

  /**
   * The severity of the error.
   */
  ErrorSeverity get errorSeverity;

  /**
   * The type of the error.
   */
  ErrorType get type;

  /**
   * The unique name of this error code.
   */
  String get uniqueName => "$runtimeType.$name";

  @override
  String toString() => uniqueName;
}

/**
 * The severity of an [ErrorCode].
 */
class ErrorSeverity implements Comparable<ErrorSeverity> {
  /**
   * The severity representing a non-error. This is never used for any error
   * code, but is useful for clients.
   */
  static const ErrorSeverity NONE = const ErrorSeverity('NONE', 0, " ", "none");

  /**
   * The severity representing an informational level analysis issue.
   */
  static const ErrorSeverity INFO = const ErrorSeverity('INFO', 1, "I", "info");

  /**
   * The severity representing a warning. Warnings can become errors if the `-Werror` command
   * line flag is specified.
   */
  static const ErrorSeverity WARNING =
      const ErrorSeverity('WARNING', 2, "W", "warning");

  /**
   * The severity representing an error.
   */
  static const ErrorSeverity ERROR =
      const ErrorSeverity('ERROR', 3, "E", "error");

  static const List<ErrorSeverity> values = const [NONE, INFO, WARNING, ERROR];

  /**
   * The name of this error code.
   */
  final String name;

  /**
   * The ordinal value of the error code.
   */
  final int ordinal;

  /**
   * The name of the severity used when producing machine output.
   */
  final String machineCode;

  /**
   * The name of the severity used when producing readable output.
   */
  final String displayName;

  /**
   * Initialize a newly created severity with the given names.
   */
  const ErrorSeverity(
      this.name, this.ordinal, this.machineCode, this.displayName);

  @override
  int get hashCode => ordinal;

  @override
  int compareTo(ErrorSeverity other) => ordinal - other.ordinal;

  /**
   * Return the severity constant that represents the greatest severity.
   */
  ErrorSeverity max(ErrorSeverity severity) =>
      this.ordinal >= severity.ordinal ? this : severity;

  @override
  String toString() => name;
}

/**
 * The type of an [ErrorCode].
 */
class ErrorType implements Comparable<ErrorType> {
  /**
   * Task (todo) comments in user code.
   */
  static const ErrorType TODO = const ErrorType('TODO', 0, ErrorSeverity.INFO);

  /**
   * Extra analysis run over the code to follow best practices, which are not in
   * the Dart Language Specification.
   */
  static const ErrorType HINT = const ErrorType('HINT', 1, ErrorSeverity.INFO);

  /**
   * Compile-time errors are errors that preclude execution. A compile time
   * error must be reported by a Dart compiler before the erroneous code is
   * executed.
   */
  static const ErrorType COMPILE_TIME_ERROR =
      const ErrorType('COMPILE_TIME_ERROR', 2, ErrorSeverity.ERROR);

  /**
   * Checked mode compile-time errors are errors that preclude execution in
   * checked mode.
   */
  static const ErrorType CHECKED_MODE_COMPILE_TIME_ERROR = const ErrorType(
      'CHECKED_MODE_COMPILE_TIME_ERROR', 3, ErrorSeverity.ERROR);

  /**
   * Static warnings are those warnings reported by the static checker. They
   * have no effect on execution. Static warnings must be provided by Dart
   * compilers used during development.
   */
  static const ErrorType STATIC_WARNING =
      const ErrorType('STATIC_WARNING', 4, ErrorSeverity.WARNING);

  /**
   * Many, but not all, static warnings relate to types, in which case they are
   * known as static type warnings.
   */
  static const ErrorType STATIC_TYPE_WARNING =
      const ErrorType('STATIC_TYPE_WARNING', 5, ErrorSeverity.WARNING);

  /**
   * Syntactic errors are errors produced as a result of input that does not
   * conform to the grammar.
   */
  static const ErrorType SYNTACTIC_ERROR =
      const ErrorType('SYNTACTIC_ERROR', 6, ErrorSeverity.ERROR);

  /**
   * Lint warnings describe style and best practice recommendations that can be
   * used to formalize a project's style guidelines.
   */
  static const ErrorType LINT = const ErrorType('LINT', 7, ErrorSeverity.INFO);

  static const List<ErrorType> values = const [
    TODO,
    HINT,
    COMPILE_TIME_ERROR,
    CHECKED_MODE_COMPILE_TIME_ERROR,
    STATIC_WARNING,
    STATIC_TYPE_WARNING,
    SYNTACTIC_ERROR,
    LINT
  ];

  /**
   * The name of this error type.
   */
  final String name;

  /**
   * The ordinal value of the error type.
   */
  final int ordinal;

  /**
   * The severity of this type of error.
   */
  final ErrorSeverity severity;

  /**
   * Initialize a newly created error type to have the given [name] and
   * [severity].
   */
  const ErrorType(this.name, this.ordinal, this.severity);

  String get displayName => name.toLowerCase().replaceAll('_', ' ');

  @override
  int get hashCode => ordinal;

  @override
  int compareTo(ErrorType other) => ordinal - other.ordinal;

  @override
  String toString() => name;
}

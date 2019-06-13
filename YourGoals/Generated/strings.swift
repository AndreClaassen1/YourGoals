// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Additional Image
  internal static let additionalImage = L10n.tr("Localizable", "Additional Image")
  /// Additional URL
  internal static let additionalURL = L10n.tr("Localizable", "Additional URL")
  /// Backburn Goal?
  internal static let backburnGoal = L10n.tr("Localizable", "Backburn Goal?")
  /// Commit Date
  internal static let commitDate = L10n.tr("Localizable", "Commit Date")
  /// Delete
  internal static let delete = L10n.tr("Localizable", "Delete")
  /// Delete Goal
  internal static let deleteGoal = L10n.tr("Localizable", "Delete Goal")
  /// Do you want a fixed begin time?
  internal static let doYouWantAFixedBeginTime = L10n.tr("Localizable", "Do you want a fixed begin time")
  /// Edit
  internal static let edit = L10n.tr("Localizable", "Edit")
  /// Enter your goal
  internal static let enterYourGoal = L10n.tr("Localizable", "Enter your goal")
  /// Goal
  internal static let goal = L10n.tr("Localizable", "Goal")
  /// Habit
  internal static let habit = L10n.tr("Localizable", "Habit")
  /// Image for your goal
  internal static let imageForYourGoal = L10n.tr("Localizable", "Image for your goal")
  /// New
  internal static let new = L10n.tr("Localizable", "New")
  /// no goal
  internal static let noGoal = L10n.tr("Localizable", "no goal")
  /// no task name
  internal static let noTaskName = L10n.tr("Localizable", "no task name")
  /// Please enter your task
  internal static let pleaseEnterYourTask = L10n.tr("Localizable", "Please enter your task")
  /// Remarks on your task
  internal static let remarksOnYourTask = L10n.tr("Localizable", "Remarks on your task")
  /// Repetition
  internal static let repetition = L10n.tr("Localizable", "Repetition")
  /// Set fixed starting time
  internal static let selectABeginTime = L10n.tr("Localizable", "Select a begin time")
  /// Select a commit date
  internal static let selectACommitDate = L10n.tr("Localizable", "Select a commit date")
  /// Select a Goal
  internal static let selectAGoal = L10n.tr("Localizable", "Select a Goal")
  /// Starting Date
  internal static let startingDate = L10n.tr("Localizable", "Starting Date")
  /// Target Date
  internal static let targetDate = L10n.tr("Localizable", "Target Date")
  /// Task
  internal static let task = L10n.tr("Localizable", "Task")
  /// The real reason for your goal
  internal static let theRealReasonForYourGoal = L10n.tr("Localizable", "The real reason for your goal")
  /// the target date must be greater than the start date
  internal static let theTargetDateMustBeGreaterThanTheStartDate = L10n.tr("Localizable", "the target date must be greater than the start date")
  /// You've overrun your task by %d minutes!
  internal static func theTimeForYourTaskIsOverrunning(_ p1: Int) -> String {
    return L10n.tr("Localizable", "The time for your task is overrunning", p1)
  }
  /// You've overrun your task by %d hours!
  internal static func theTimeForYourTaskIsOverrunningInHours(_ p1: Int) -> String {
    return L10n.tr("Localizable", "The time for your task is overrunning in hours", p1)
  }
  /// Timebox your task
  internal static let timeboxYourTask = L10n.tr("Localizable", "Timebox your task")
  /// You have only 10 Minutes left for your task!
  internal static let youHaveOnly10MinutesLeftForYourTask = L10n.tr("Localizable", "You have only 10 Minutes left for your task!")
  /// You have only 5 Minutes left for your task!
  internal static let youHaveOnly5MinutesLeftForYourTask = L10n.tr("Localizable", "You have only 5 Minutes left for your task!")
  /// You have reached 50% of your timebox
  internal static func youHaveReached50OfYourTimebox(_ p1: Int) -> String {
    return L10n.tr("Localizable", "You have reached 50% of your timebox", p1)
  }
  /// Your time is up!
  internal static let yourTimeIsUp = L10n.tr("Localizable", "Your time is up!")

  internal enum YourTaskIsStartet {
    /// Your Task is startet. Do your work!
    internal static let doYourWork = L10n.tr("Localizable", "Your Task is startet. Do your work!")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

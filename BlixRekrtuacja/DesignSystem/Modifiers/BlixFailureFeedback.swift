import SwiftUI

/// A failure that keeps its place on screen (a failed retry) shakes it and plays error haptics instead of an alert.
struct BlixFailureFeedback: ViewModifier {
    /// A count of failures: every change replays the feedback.
    let trigger: Int

    func body(content: Content) -> some View {
        content
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: trigger) { view, offset in
                view.offset(x: offset)
            } keyframes: { _ in
                KeyframeTrack {
                    LinearKeyframe(Motion.shakeOffset, duration: Motion.shakeStep)
                    LinearKeyframe(-Motion.shakeOffset, duration: Motion.shakeStep)
                    LinearKeyframe(Motion.shakeSettleOffset, duration: Motion.shakeStep)
                    LinearKeyframe(-Motion.shakeSettleOffset, duration: Motion.shakeStep)
                    LinearKeyframe(.zero, duration: Motion.shakeStep)
                }
            }
            .sensoryFeedback(.error, trigger: trigger)
    }
}

extension View {
    func failureFeedback(trigger: Int) -> some View {
        modifier(BlixFailureFeedback(trigger: trigger))
    }
}

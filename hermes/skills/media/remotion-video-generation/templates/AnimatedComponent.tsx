import { useCurrentFrame, interpolate, Easing } from "remotion";

interface AnimatedComponentProps {
  startFrame: number;
  durationInFrames: number;
  children: React.ReactNode;
}

/**
 * AnimatedComponent — template for any Remotion component that needs to
 * appear/disappear at a specific time with smooth easing.
 *
 * Copy this pattern for all animated overlays, mockups, notifications, etc.
 *
 * Key rules:
 * 1. Accept startFrame + durationInFrames props
 * 2. Calculate relativeFrame = frame - startFrame
 * 3. Return null when outside active window (with buffer for transitions)
 * 4. Use interpolate with extrapolate clamp
 * 5. Apply Easing.out(Easing.cubic) to all animated properties
 * 6. NEVER use CSS transition or animation
 */
export const AnimatedComponent: React.FC<AnimatedComponentProps> = ({
  startFrame,
  durationInFrames,
  children,
}) => {
  const frame = useCurrentFrame();
  const relativeFrame = frame - startFrame;

  // Buffer for fade in/out transitions
  if (relativeFrame < -15 || relativeFrame >= durationInFrames + 15) return null;

  const opacity = interpolate(
    relativeFrame,
    [0, 10, durationInFrames - 10, durationInFrames],
    [0, 1, 1, 0],
    { extrapolateLeft: "clamp", extrapolateRight: "clamp", easing: Easing.out(Easing.cubic) }
  );

  const scale = interpolate(
    relativeFrame,
    [0, 15],
    [0.96, 1],
    { extrapolateLeft: "clamp", extrapolateRight: "clamp", easing: Easing.out(Easing.back(1.3)) }
  );

  return (
    <div
      style={{
        position: "absolute",
        top: "50%",
        left: "50%",
        transform: `translate(-50%, -50%) scale(${scale})`,
        opacity,
        zIndex: 50,
      }}
    >
      {children}
    </div>
  );
};

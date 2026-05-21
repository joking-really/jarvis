import { Audio, staticFile, Sequence } from "remotion";

interface AudioSegmentProps {
  src: string;
  startFrame: number;
  durationInFrames: number;
  fadeInFrames?: number;
  fadeOutFrames?: number;
  volume?: number;
}

/**
 * AudioSegment — wraps an Audio element in a Sequence for proper timeline positioning.
 *
 * CRITICAL: In Remotion, `<Audio startFrom={n}>` controls where in the audio FILE
 * to start playing, NOT when in the composition TIMELINE to start. Without a
 * `<Sequence>` wrapper, all Audio elements play from frame 0 simultaneously,
 * causing audio doubling/overlap.
 *
 * Usage:
 *   <AudioSegment src="hook.mp3" startFrame={0} durationInFrames={171} />
 *   <AudioSegment src="problem.mp3" startFrame={171} durationInFrames={246} />
 */
export const AudioSegment: React.FC<AudioSegmentProps> = ({
  src,
  startFrame,
  durationInFrames,
  fadeInFrames = 5,
  fadeOutFrames = 5,
  volume = 1,
}) => {
  return (
    <Sequence from={startFrame} durationInFrames={durationInFrames}>
      <Audio
        src={staticFile(src)}
        startFrom={0}
        endAt={durationInFrames}
        volume={(f) => {
          const relativeFrame = f;
          if (relativeFrame < 0 || relativeFrame >= durationInFrames) return 0;

          const fadeIn = Math.min(relativeFrame / fadeInFrames, 1);
          const fadeOut = Math.min(
            (durationInFrames - relativeFrame) / fadeOutFrames,
            1
          );

          return fadeIn * fadeOut * volume;
        }}
      />
    </Sequence>
  );
};

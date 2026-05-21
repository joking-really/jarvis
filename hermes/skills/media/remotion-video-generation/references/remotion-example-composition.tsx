// Complete working example: Top-of-Funnel reel composition
// Copy into src/Composition.tsx and adjust timings for your script

import {
  AbsoluteFill,
  Audio,
  Sequence,
  staticFile,
  Video,
  Img,
  interpolate,
  useCurrentFrame,
} from "remotion";

// Fade-in text component
const FadeInText = ({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) => {
  const frame = useCurrentFrame();
  const opacity = interpolate(frame, [0, 15], [0, 1], {
    extrapolateRight: "clamp",
  });
  const translateY = interpolate(frame, [0, 15], [20, 0], {
    extrapolateRight: "clamp",
  });

  return (
    <div
      style={{ opacity, transform: `translateY(${translateY}px)` }}
      className={className}
    >
      {children}
    </div>
  );
};

export const TOFReel = () => {
  return (
    <AbsoluteFill className="bg-[#0A0A0F] font-sans">
      {/* === HOOK SEGMENT: 0-3.5s (0-105 frames) === */}
      <Sequence from={0} durationInFrames={105}>
        <Audio src={staticFile("assets/hook.mp3")} />
        <AbsoluteFill className="flex items-center justify-center px-12">
          <FadeInText>
            <h1 className="text-white text-5xl font-bold text-center leading-tight">
              Most clinics lose leads while the receptionist is eating lunch.
            </h1>
          </FadeInText>
        </AbsoluteFill>
      </Sequence>

      {/* === PROBLEM SEGMENT: 3.5-10s (105-315 frames) === */}
      <Sequence from={105} durationInFrames={210}>
        <Audio src={staticFile("assets/problem.mp3")} />
        {/* Stock footage background at low opacity */}
        <Video
          src={staticFile("assets/office-dark.mp4")}
          className="absolute inset-0 w-full h-full object-cover opacity-40"
        />
        {/* Dark overlay for text readability */}
        <div className="absolute inset-0 bg-black/50" />
        <AbsoluteFill className="flex items-center justify-center px-12 relative z-10">
          <FadeInText>
            <p className="text-white text-3xl text-center leading-relaxed">
              Your highest-intent leads don't call at 10 AM on a Tuesday. They
              call at 1:15 PM. During lunch. After hours. On Sunday. And they
              don't leave voicemails. They call the next clinic on the list.
            </p>
          </FadeInText>
        </AbsoluteFill>
      </Sequence>

      {/* === OBSERVATION SEGMENT: 10-17s (315-525 frames) === */}
      <Sequence from={315} durationInFrames={210}>
        <Audio src={staticFile("assets/observation.mp3")} />
        {/* Call log mockup background */}
        <Img
          src={staticFile("assets/call-log.png")}
          className="absolute inset-0 w-full h-full object-cover opacity-25"
        />
        <div className="absolute inset-0 bg-black/60" />
        <AbsoluteFill className="flex items-center justify-center px-12 relative z-10">
          <FadeInText>
            <p className="text-[#00F0FF] text-4xl font-bold text-center leading-tight">
              The first business to respond usually gets paid.
            </p>
            <p className="text-[#8A8F98] text-xl text-center mt-4">
              Not the best. Not the cheapest. The fastest.
            </p>
          </FadeInText>
        </AbsoluteFill>
      </Sequence>

      {/* === TENSION SEGMENT: 17-28s (525-840 frames) === */}
      <Sequence from={525} durationInFrames={315}>
        <Audio src={staticFile("assets/tension.mp3")} />
        <AbsoluteFill className="flex items-center justify-center px-12">
          <FadeInText>
            <p className="text-white text-3xl text-center leading-relaxed">
              They already decided to call you. That's the hard part. And most
              businesses still lose them.
            </p>
            <p className="text-[#00F0FF] text-2xl text-center mt-6 font-semibold">
              Response time is a revenue system.
            </p>
            <p className="text-[#8A8F98] text-xl text-center mt-2">
              Most don't realize this until revenue drops.
            </p>
          </FadeInText>
        </AbsoluteFill>
      </Sequence>

      {/* === CLOSE SEGMENT: 28-31s (840-930 frames) === */}
      <Sequence from={840} durationInFrames={90}>
        <Audio src={staticFile("assets/close.mp3")} />
        <AbsoluteFill className="flex items-center justify-center">
          <FadeInText>
            <p className="text-white text-6xl font-bold text-center">
              Speed compounds.
            </p>
          </FadeInText>
        </AbsoluteFill>
      </Sequence>
    </AbsoluteFill>
  );
};

// Register in Root.tsx:
// <Composition
//   id="TOF-Reel"
//   component={TOFReel}
//   durationInFrames={930}
//   fps={30}
//   width={1080}
//   height={1920}
// />

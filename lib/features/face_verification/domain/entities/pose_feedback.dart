/// What the liveness pose evaluator tells the user about their current
/// camera frame, in priority order — the first applicable reason wins.
/// [ok] means the current pose matches the step's target and the hold
/// timer may run.
enum PoseFeedback {
  noFace,
  multipleFaces,
  moveCloser,
  moveBack,
  centerFace,
  lookStraight,
  turnLeft,
  turnRight,
  openEyes,
  holdStill,
  ok,
}

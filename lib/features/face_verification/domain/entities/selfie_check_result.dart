/// Outcome of the on-device selfie gate. Only [ok] may be submitted.
///
/// Deliberately not identity matching: comparing the selfie to the profile
/// photo happens server-side (e.g. AWS Rekognition `CompareFaces`), because
/// a client-side verdict can be faked. The app only guarantees "a single,
/// frontal, eyes-open face" before uploading.
enum SelfieCheckResult { ok, noFace, multipleFaces, notFrontal, eyesClosed }

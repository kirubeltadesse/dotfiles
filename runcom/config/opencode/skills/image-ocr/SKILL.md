---
name: image-ocr
description: Extract text from an image on macOS using the built-in Vision framework (Swift). Use when the user shares or references an image file - screenshot, photo, scan, PNG/JPG - and its text content is needed, or when an image attachment cannot be viewed directly (e.g. "read the text from this image", "what does this screenshot say", "can you see this question"). No third-party tools or network required.
---

# Image OCR (macOS Vision)

Extracts text from an image using macOS's built-in OCR (Vision framework). No downloads, no API keys - requires only Xcode Command Line Tools (`swift` on PATH).

## When to use

- The user shares an image (screenshot, photo, scan) and you need its text.
- An attached image cannot be viewed directly by the model - OCR is the fallback.
- The user asks "can you read this image" or pastes an image path.

## How to run

1. Write the script below to a temp file (e.g. `/var/folders/.../T/opencode/ocr.swift`).
2. Run: `swift ocr.swift <image-path>`
3. Output is printed in reading order: top-to-bottom, left-to-right within a line, blank line between visually distinct blocks.

## The script

```swift
import Vision
import AppKit

guard CommandLine.arguments.count > 1 else {
    print("usage: swift ocr.swift <image-path>")
    exit(1)
}
let path = CommandLine.arguments[1]
guard let image = NSImage(contentsOfFile: path),
      let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
    print("could not load image at \(path)")
    exit(1)
}

let request = VNRecognizeTextRequest { req, _ in
    guard let observations = req.results as? [VNRecognizedTextObservation] else { return }
    let sorted = observations.sorted { a, b in
        if abs(a.boundingBox.midY - b.boundingBox.midY) > 0.02 {
            return a.boundingBox.midY > b.boundingBox.midY   // top-to-bottom
        }
        return a.boundingBox.minX < b.boundingBox.minX       // left-to-right within a line
    }
    var lastY: CGFloat = .infinity
    for obs in sorted {
        if lastY != .infinity && lastY - obs.boundingBox.midY > 0.06 {
            print("")   // blank line separates visually distinct blocks
        }
        if let candidate = obs.topCandidates(1).first {
            print(candidate.string)
        }
        lastY = obs.boundingBox.midY
    }
}
request.recognitionLevel = .accurate
request.usesLanguageCorrection = true

let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
try handler.perform([request])
```

## Caveats

- OCR is approximate. Brackets/parens (`[` vs `(`), dashes, and unicode can be mangled - seen in practice: `(-1, 0, 1, -1, 0, 1, 01` came out of `[-1, 0, 1, -1, 0, 1, 0]`). Cross-check garbled lines against context.
- `usesLanguageCorrection = true` autocorrects words (good for prose, may mangle code/identifiers). For code-heavy images, set it to `false` and re-run.
- `recognitionLevel = .accurate` is slowest but best; switch to `.fast` for huge images.
- Coordinates: Vision origin is bottom-left; the sort above already handles this.
- Requires macOS + Xcode Command Line Tools. If `swift` is missing, tell the user and offer the platform alternative (e.g. iOS Shortcuts OCR) instead of failing silently.
- For images where layout matters (tables, math), present the raw output and ask the user to confirm anything that looks wrong.

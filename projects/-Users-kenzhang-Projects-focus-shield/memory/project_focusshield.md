---
name: focus_shield_project
description: Context for the Focus Shield Android app project — architecture, goals, and current state
type: project
---

Focus Shield is an open source Android app that blocks addictive short-form video features (YouTube Shorts first, then Instagram Reels, TikTok, etc.) using Android's Accessibility Service — no root required.

**Why:** User wants to combat doom scrolling without fully disconnecting from social platforms.

**How to apply:** When discussing this project, keep extensibility in mind — the ContentDetector interface is the core extension point. Everything routes through DetectorRegistry.

## Current State (March 2026)
All source files generated and ready for Android Studio setup. User still needs to:
1. Open in Android Studio (it will download the Gradle wrapper automatically)
2. Sync Gradle
3. Run on a physical device
4. Enable the Accessibility Service in Settings

## Key Architecture Decisions
- **Language**: Kotlin
- **UI**: Jetpack Compose + Material3
- **DI**: Hilt (`@AndroidEntryPoint` on service)
- **Settings**: DataStore Preferences
- **Detection**: AccessibilityService → DetectorRegistry → ContentDetector implementations
- **Action**: `performGlobalAction(GLOBAL_ACTION_BACK)` with 1500ms cooldown

## Package Structure
`com.focusshield` — base package for all code

## YouTube Shorts Resource IDs (last known working)
- `com.google.android.youtube:id/reel_watch_player`
- `com.google.android.youtube:id/shorts_container`
- `com.google.android.youtube:id/reel_shelf`
- `com.google.android.youtube:id/reel_shelf_title`
- `com.google.android.youtube:id/pivot_shorts`

These may change with YouTube updates. See DEVELOPER_HANDBOOK.md §10 for how to find new IDs.

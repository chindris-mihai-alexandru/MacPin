# PWA-Kit Roadmap

## Project Vision

**PWA-Kit** is the power tool for web apps on macOS. While Safari's "Add to Dock" creates basic web app windows, PWA-Kit creates **smart, customizable containers** with per-app ad blocking, script injection, custom styling, and more.

**Tagline**: "Your web apps, your rules."

---

## Current Status (December 16, 2025)

### ✅ Build Status: SUCCESS
- **Swift**: 5.10+ (6.0 compatible)
- **macOS**: 14.0+ (Sonoma)
- **Architecture**: arm64 (Apple Silicon)

### ✅ Phase 0: Content Blocking - COMPLETE
- `ContentBlocker.swift` implemented with full WKContentRuleListStore support
- Predefined rule sets: ads, trackers, cookies, social widgets, HTTPS upgrade
- Custom rule builder API
- Bundle JSON rules for ads and trackers

---

## Phase 1: Content Blocking Polish (Week 1-2)

**Goal**: Make content blocking production-ready and user-facing.

### 1.1 WebView Integration ✅ Priority: HIGH

**Tasks**:
- [ ] Add `contentBlocking: Bool` option to MPWebViewConfig
- [ ] Auto-apply default blocking rules on WebView creation
- [ ] Add JavaScript API: `$.browser.enableAdBlocking()`
- [ ] Add JavaScript API: `$.browser.enableTrackerBlocking()`

**Example Usage**:
```javascript
// In app's main.js
let tab = $.browser.tabSelected;
tab.enableAdBlocking();
tab.enableTrackerBlocking();
```

### 1.2 Settings Persistence ✅ Priority: MEDIUM

**Tasks**:
- [ ] Store blocking preferences in UserDefaults
- [ ] Per-app blocking configuration
- [ ] Global default settings

### 1.3 Testing & Validation ✅ Priority: HIGH

**Test Sites**:
- CNN.com (heavy ads)
- Forbes.com (ad walls)
- YouTube.com (pre-roll ads - note: may not block video ads)
- Reddit.com (promoted posts)

**Success Criteria**:
- Ads not visible on test sites
- Pages still function correctly
- No JavaScript errors from blocked content

---

## Phase 2: CSS/JS Injection Engine (Week 3-4)

**Goal**: Allow users to customize any web app's appearance and behavior.

### 2.1 Enhanced Injection UI ✅ Priority: HIGH

**Current**: Scripts/styles loaded from bundle resources only.

**Improvement**: Runtime injection with hot-reload.

**Tasks**:
- [ ] Create `ScriptInjector.swift` with runtime injection
- [ ] Support Greasemonkey/Tampermonkey metadata blocks
- [ ] Add file watcher for CSS hot-reload
- [ ] Create JavaScript API for injection management

### 2.2 Example Use Cases

**Dark Mode for Any Site**:
```css
/* enDarken.css */
html {
    filter: invert(1) hue-rotate(180deg);
}
img, video, [style*="background-image"] {
    filter: invert(1) hue-rotate(180deg);
}
```

**Remove Distractions from YouTube**:
```javascript
// youtube-focus.js
// ==UserScript==
// @name YouTube Focus
// @match *://www.youtube.com/*
// ==/UserScript==

document.querySelectorAll('#related, #comments, ytd-ad-slot-renderer')
    .forEach(el => el.remove());
```

### 2.3 Script/Style Marketplace Concept

**Future Vision**: Community-contributed mods
- "Gmail Minimal" - Remove sidebar clutter
- "Twitter Focus" - Hide trends and recommendations
- "Notion Dark" - True dark theme

---

## Phase 3: Built-in Block Lists (Week 5-6)

**Goal**: Integrate popular ad blocking lists.

### 3.1 EasyList Integration ✅ Priority: MEDIUM

**Tasks**:
- [ ] Parse EasyList format to WebKit JSON rules
- [ ] Create update mechanism for block lists
- [ ] Add UI for list selection
- [ ] Implement list caching

**Block Lists to Support**:
- EasyList (ads)
- EasyPrivacy (trackers)
- Fanboy's Annoyance List (social, cookies notices)
- Regional lists (optional)

### 3.2 Custom List Support

**Tasks**:
- [ ] Allow importing custom block list URLs
- [ ] Validate and compile lists on import
- [ ] Store compiled lists for performance

---

## Phase 4: Optional AI Sidebar (Week 7-10)

**Goal**: Integrate local LLMs for "smart" web app interaction.

### 4.1 Ollama Integration ✅ Priority: MEDIUM

**Architecture**:
```
┌─────────────────────────────────────────┐
│ PWA-Kit Window                          │
├─────────────────────┬───────────────────┤
│                     │ AI Sidebar        │
│   Web App Content   │                   │
│   (WKWebView)       │ [Model: llama3]   │
│                     │                   │
│                     │ "Summarize this   │
│                     │  page for me"     │
│                     │                   │
│                     │ [Response area]   │
│                     │                   │
└─────────────────────┴───────────────────┘
```

**Tasks**:
- [ ] Create `OllamaClient.swift` for API communication
- [ ] Build SwiftUI sidebar panel
- [ ] Implement page context extraction (DOM to text)
- [ ] Add streaming response display
- [ ] Settings for model selection and endpoint

### 4.2 Privacy Focus

**Key Differentiator**: All AI processing is LOCAL
- No data sent to cloud
- Works offline (with downloaded models)
- User owns their conversation history

### 4.3 Use Cases

- "Summarize this article"
- "Draft a reply to this email"
- "Explain this error message"
- "What are the key points of this document?"

---

## Phase 5: GUI App Builder (Week 11-14)

**Goal**: Visual app creation without command line.

### 5.1 PWAKitBuilder App ✅ Priority: HIGH

**Tech Stack**: SwiftUI + Combine

**Features**:
- URL input with validation
- App name input
- Icon import (drag-drop or file picker)
- Automatic favicon fetching
- Content blocking toggles
- Custom CSS/JS editor
- Live preview
- One-click "Create App" button

### 5.2 UI Design

```
┌─────────────────────────────────────────┐
│ PWA-Kit Builder                    [_][□][×] │
├─────────────────────────────────────────┤
│                                         │
│  App URL:    [https://gmail.com      ]  │
│  App Name:   [Gmail                  ]  │
│                                         │
│  Icon:       [🖼️ Drop icon here     ]   │
│              [□ Fetch from website   ]  │
│                                         │
│  ── Privacy & Blocking ──────────────   │
│  [✓] Block Ads                          │
│  [✓] Block Trackers                     │
│  [ ] Block Third-Party Cookies          │
│  [ ] Block Social Widgets               │
│                                         │
│  ── Advanced ─────────────────────────  │
│  [▶] Custom CSS                         │
│  [▶] Custom JavaScript                  │
│  [▶] Custom User Agent                  │
│                                         │
│              [Create App]               │
│                                         │
└─────────────────────────────────────────┘
```

### 5.3 Monetization

**PWAKitBuilder** is the commercial product:
- Closed-source SwiftUI app
- Calls PWA-Kit CLI under the hood
- Sold on Gumroad: Pay-What-You-Want, suggested $29
- Legal: Separate codebase, not GPL-derived

---

## Phase 6: Polish & Release (Week 15-16)

### 6.1 Documentation ✅ Priority: HIGH

**Create**:
- [ ] User guide for creating apps
- [ ] Developer guide for contributing
- [ ] JavaScript API reference
- [ ] Troubleshooting guide

### 6.2 Testing ✅ Priority: HIGH

**Test Matrix**:
- macOS 14 (Sonoma)
- macOS 15 (Sequoia)
- arm64 (Apple Silicon)
- x86_64 (Intel) - stretch goal

### 6.3 Launch Preparation

**Checklist**:
- [ ] Update README with new value proposition
- [ ] Create demo video
- [ ] Prepare Hacker News post
- [ ] Set up GitHub Sponsors
- [ ] Create landing page

---

## Success Metrics

### Phase 1-2 (Content Blocking + Injection)
- ✅ Ads blocked on test sites
- ✅ Custom CSS applies correctly
- ✅ No site breakage

### Phase 3-4 (Block Lists + AI)
- ✅ EasyList rules compile and apply
- ✅ Ollama sidebar functional
- ✅ Page summarization works

### Phase 5-6 (Builder + Release)
- ✅ GUI builder creates working apps
- ✅ 100+ GitHub stars within 1 month
- ✅ PWAKitBuilder sells on Gumroad

---

## Future Enhancements (Post-v1.0)

### Menu Bar Apps
- Lightweight apps in menu bar
- Click to show popup (like Slack status)

### Notification Badges
- Show unread counts on Dock icon
- Requires webpage JavaScript API

### Per-App Proxy (Advanced)
- Route specific apps through SOCKS5 proxy
- Useful for geo-restricted content
- Requires NEAppProxyProvider research

### iOS Version
- Port to iOS/iPadOS
- Share core WebKit wrapper code

---

## Timeline Summary

| Phase | Focus | Duration | Target Date |
|-------|-------|----------|-------------|
| 0 | Content Blocker Core | 1 week | ✅ Complete |
| 1 | Content Blocking Polish | 2 weeks | Dec 30, 2025 |
| 2 | CSS/JS Injection | 2 weeks | Jan 13, 2026 |
| 3 | Block Lists | 2 weeks | Jan 27, 2026 |
| 4 | AI Sidebar | 4 weeks | Feb 24, 2026 |
| 5 | GUI Builder | 4 weeks | Mar 24, 2026 |
| 6 | Polish & Release | 2 weeks | Apr 7, 2026 |

**v1.0 Target**: April 7, 2026

---

## Resources

- **WebKit Content Blockers**: https://webkit.org/blog/3476/content-blockers-first-look/
- **WKContentRuleListStore**: https://developer.apple.com/documentation/webkit/wkcontentruleliststore
- **Ollama API**: https://github.com/ollama/ollama/blob/main/docs/api.md
- **EasyList**: https://easylist.to/

---

**Last Updated**: December 16, 2025  
**Maintainer**: @chindris-mihai-alexandru

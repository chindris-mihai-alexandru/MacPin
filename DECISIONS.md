# PWA-Kit Strategic Decisions

**Date**: December 16, 2025  
**Status**: Major Pivot - From "Memory Saver" to "Power Tool for Web Apps"

---

## The Pivot: Why We Changed Direction

### The Problem (November 2025)
Our original value proposition was weak:
- Safari's "Add to Dock" (macOS Sonoma) now creates proper PWAs
- "200-300MB RAM savings" isn't compelling for most users
- Competing with free built-in solution + paid polished apps (Unite $30, Coherence $40)

### The Solution (December 2025)
**Stop building a "worse Safari" and start building a "Power Tool for Web Apps"**

Safari's Add to Dock creates dumb windows. PWA-Kit creates **smart, customizable** web app containers with features Safari cannot provide due to Apple's philosophy of simplicity.

---

## New Value Proposition

### What PWA-Kit Does That Safari Cannot

| Feature | Safari PWA | PWA-Kit |
|---------|------------|---------|
| **Ad Blocking** | ❌ No | ✅ Per-app content blockers |
| **Tracker Blocking** | ❌ No | ✅ Built-in privacy protection |
| **JS Injection** | ❌ No | ✅ UserScript/Greasemonkey-style |
| **CSS Injection** | ❌ No | ✅ Custom stylesheets per app |
| **Custom User-Agent** | ❌ No | ✅ Per-app configuration |
| **Proxy per App** | ❌ No | ✅ Route specific apps through proxies |
| **AI Integration** | ❌ No | ✅ Local LLM sidebar (planned) |
| **Session Control** | ❌ Isolated only | ✅ Configurable isolation |

---

## Critical Decisions Made

### 1. **Pivot to "Power Tool" Model** ✅ NEW

**Decision**: Focus on features Safari PWAs cannot do

**Priority Order**:
1. **Phase 0**: Per-app content blocking (ads, trackers) - COMPLETED
2. **Phase 1**: CSS/JS injection engine with UI
3. **Phase 2**: Built-in ad block lists (EasyList integration)
4. **Phase 3**: Optional AI sidebar (Ollama integration)

**Rationale**:
- Content blocking is immediate, tangible value
- "Block ads in your web apps" is a clear marketing message
- Builds on existing WKContentRuleListStore capability
- Low effort, high impact

### 2. **ContentBlocker Implementation** ✅ NEW

**Decision**: Implement robust content blocking system

**Components Created**:
- `Sources/MacPin/ContentBlocker.swift` - Main blocking engine
- `templates/Resources/content-blocker-ads.json` - Ad network rules
- `templates/Resources/content-blocker-trackers.json` - Tracker rules

**Features**:
- Predefined rule sets: ads, trackers, cookies, social, HTTPS upgrade
- Custom rule builder API
- Per-WebView application
- Enable/disable at runtime

### 3. **Project Naming: Keep "PWA-Kit" for Now** ✅

**Decision**: Keep GitHub fork as `PWA-Kit` until v1.0

**Reasoning**:
- Original MacPin has **339 stars** and brand recognition
- Better SEO: "PWA-Kit modernized" > "unknown project"
- Gradual transition strategy:
  - **v0.1-0.4**: Market as "PWA-Kit - The Power Tool for Web Apps"
  - **v0.5+**: Evaluate rebrand based on community feedback
  - **v1.0**: Potential rebrand if significant traction

### 4. **Upstream Strategy: Independent Fork** ✅

**Decision**: Maintain independent fork, do NOT submit PRs to kfix/MacPin

**Reasoning**:
1. Original repo inactive (last commit Nov 2022, 3 years old)
2. Our direction is fundamentally different (power tool vs educational)
3. Changes are extensive and break backward compatibility

**License Compliance**:
- ✅ Keep GPL-3.0 license
- ✅ Maintain copyright attributions
- ✅ Credit MacPin in README prominently

### 5. **Swift Version: 5.10 Now, 6.0 Later** ✅

**Decision**: Ship initial versions with Swift 5.10

**Rationale**:
- Swift 6 strict concurrency is correct but time-consuming
- Better to ship working MVP fast
- Community can help fix concurrency issues once interested

### 6. **Distribution: Homebrew + DMG, No App Store** ✅

**Decision**: Distribute via Homebrew Cask initially

**Why No App Store**:
- Requires $99/year (no budget yet)
- GPL license conflicts with App Store terms
- Review process slow
- Can't distribute generated PWAs via App Store anyway

### 7. **GUI App Builder: SwiftUI + Combine** ✅

**Decision**: Pure SwiftUI for app builder UI

**Architecture**:
```swift
// Future GUI app structure
@MainActor
class AppConfiguration: ObservableObject {
    @Published var url: String = ""
    @Published var name: String = ""
    @Published var enableAdBlocking: Bool = true
    @Published var enableTrackerBlocking: Bool = true
    @Published var customCSS: String = ""
    @Published var customJS: String = ""
}
```

---

## Competitive Analysis

### Pricing Landscape

| Tool | Price | Open Source | Content Blocking |
|------|-------|-------------|------------------|
| Safari "Add to Dock" | Free | N/A | ❌ No |
| Unite 6 | $29.99 | ❌ No | ✅ Yes |
| Coherence X5 | $39.99 | ❌ No | Via extensions |
| **PWA-Kit** | Free | ✅ Yes | ✅ Yes |

### Our Advantages

1. **Free and open-source** - No $30-40 cost
2. **Per-app content blocking** - Safari PWAs can't do this
3. **Fully scriptable** - JavaScript runtime per site
4. **Privacy-first** - No telemetry, local-only
5. **Community-driven** - Contributors welcome

---

## Key Performance Indicators (KPIs)

### Technical Success
- ✅ Content blocker compiles and applies rules
- ⏳ Ad-heavy sites load without ads
- ⏳ Memory usage remains reasonable (<150MB per app)

### Community Success
- **v0.1 (Week 4)**: 50+ GitHub stars
- **v0.3 (Week 8)**: 200+ stars, 5+ community PRs
- **v0.5 (Week 12)**: 500+ stars
- **v1.0 (Week 24)**: 1,000+ stars, 50+ contributors

### Failure Indicators (pivot if these happen)
- <20 stars after launch → marketing problem
- 0 community PRs after 2 months → code too complex
- Content blocking breaks sites → need better rules

---

## Next Immediate Actions

### This Week
1. ✅ Implement ContentBlocker.swift
2. ✅ Create ad/tracker blocking JSON rules
3. ⏳ Integrate content blocker into WebView initialization
4. ⏳ Add JavaScript API for toggling blockers
5. ⏳ Test against ad-heavy sites (CNN, Forbes)

### Next Week
1. Start CSS/JS injection UI
2. Create example apps with blocking enabled
3. Update README with new value proposition
4. Prepare demo video showing ad blocking

---

## Questions to Revisit

1. **AI Sidebar**: Worth the effort vs crowded AI space?
   - Decision deferred to Phase 3, gauge community interest

2. **Proxy per App**: How hard is NEAppProxyProvider?
   - Decision: Research in Phase 2, may be too complex

3. **Monetization**: Still viable with free competition?
   - Decision: PWAKitBuilder GUI app on Gumroad remains the plan

---

**Last Updated**: December 16, 2025  
**Next Review**: January 1, 2026

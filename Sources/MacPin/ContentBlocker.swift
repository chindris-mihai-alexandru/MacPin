/// MacPin ContentBlocker
///
/// Per-app content blocking using WKContentRuleListStore
/// This is a key differentiator from Safari's "Add to Dock" PWAs which cannot block ads

import Foundation
import WebKit

/// Manages content blocking rules for WebViews
/// Provides per-app ad blocking, tracker blocking, and custom rules
@available(macOS 10.13, iOS 11, *)
@objcMembers
public class ContentBlocker: NSObject {
    
    // MARK: - Singleton
    
    /// Shared instance for app-wide content blocking
    public static let shared = ContentBlocker()
    
    // MARK: - Properties
    
    /// Currently loaded rule list identifiers
    private(set) var loadedRuleLists: [String: WKContentRuleList] = [:]
    
    /// Compilation queue for thread safety
    private let compilationQueue = DispatchQueue(label: "com.macpin.contentblocker", qos: .userInitiated)
    
    /// Default rule store
    private var ruleStore: WKContentRuleListStore {
        return WKContentRuleListStore.default()
    }
    
    // MARK: - Built-in Rule Sets
    
    /// Common ad network domains to block
    public static let adBlockRules: String = """
    [
        {
            "trigger": {
                "url-filter": ".*",
                "if-domain": ["*doubleclick.net", "*googlesyndication.com", "*googleadservices.com", "*google-analytics.com", "*adsserver.*", "*adservice.*"]
            },
            "action": {
                "type": "block"
            }
        },
        {
            "trigger": {
                "url-filter": ".*ads.*\\\\.js"
            },
            "action": {
                "type": "block"
            }
        },
        {
            "trigger": {
                "url-filter": ".*\\\\/ad[sx]?\\\\/.*"
            },
            "action": {
                "type": "block"
            }
        },
        {
            "trigger": {
                "url-filter": ".*\\\\.gif\\\\?.*tracking",
                "resource-type": ["image"]
            },
            "action": {
                "type": "block"
            }
        }
    ]
    """
    
    /// Common tracker domains to block
    public static let trackerBlockRules: String = """
    [
        {
            "trigger": {
                "url-filter": ".*",
                "if-domain": ["*facebook.com", "*fbcdn.net"],
                "load-type": ["third-party"]
            },
            "action": {
                "type": "block"
            }
        },
        {
            "trigger": {
                "url-filter": ".*",
                "if-domain": ["*analytics.*", "*tracker.*", "*tracking.*", "*telemetry.*"],
                "load-type": ["third-party"]
            },
            "action": {
                "type": "block"
            }
        },
        {
            "trigger": {
                "url-filter": ".*beacon.*",
                "resource-type": ["image", "script"]
            },
            "action": {
                "type": "block"
            }
        },
        {
            "trigger": {
                "url-filter": ".*pixel\\\\..*",
                "resource-type": ["image"]
            },
            "action": {
                "type": "block"
            }
        }
    ]
    """
    
    /// Block third-party cookies
    public static let cookieBlockRules: String = """
    [
        {
            "trigger": {
                "url-filter": ".*",
                "load-type": ["third-party"]
            },
            "action": {
                "type": "block-cookies"
            }
        }
    ]
    """
    
    /// Upgrade HTTP to HTTPS
    public static let httpsUpgradeRules: String = """
    [
        {
            "trigger": {
                "url-filter": ".*",
                "resource-type": ["document"]
            },
            "action": {
                "type": "make-https"
            }
        }
    ]
    """
    
    /// Social media widgets/embeds blocker
    public static let socialBlockRules: String = """
    [
        {
            "trigger": {
                "url-filter": ".*",
                "if-domain": ["*facebook.com", "*twitter.com", "*linkedin.com", "*pinterest.com"],
                "load-type": ["third-party"],
                "resource-type": ["script", "image"]
            },
            "action": {
                "type": "block"
            }
        },
        {
            "trigger": {
                "url-filter": ".*share.*button.*",
                "load-type": ["third-party"]
            },
            "action": {
                "type": "block"
            }
        }
    ]
    """
    
    // MARK: - Predefined Rule Set Identifiers
    
    public enum RuleSet: String, CaseIterable {
        case ads = "macpin.rules.ads"
        case trackers = "macpin.rules.trackers"
        case cookies = "macpin.rules.cookies"
        case httpsUpgrade = "macpin.rules.https"
        case social = "macpin.rules.social"
        
        var jsonRules: String {
            switch self {
            case .ads: return ContentBlocker.adBlockRules
            case .trackers: return ContentBlocker.trackerBlockRules
            case .cookies: return ContentBlocker.cookieBlockRules
            case .httpsUpgrade: return ContentBlocker.httpsUpgradeRules
            case .social: return ContentBlocker.socialBlockRules
            }
        }
        
        var displayName: String {
            switch self {
            case .ads: return "Block Ads"
            case .trackers: return "Block Trackers"
            case .cookies: return "Block Third-Party Cookies"
            case .httpsUpgrade: return "Upgrade to HTTPS"
            case .social: return "Block Social Widgets"
            }
        }
    }
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
    }
    
    // MARK: - Public API
    
    /// Compile and cache a rule list from JSON string
    /// - Parameters:
    ///   - identifier: Unique identifier for this rule list
    ///   - jsonRules: JSON string containing content blocking rules
    ///   - completion: Called with the compiled rule list or error
    public func compileRules(
        identifier: String,
        jsonRules: String,
        completion: @escaping (Result<WKContentRuleList, Error>) -> Void
    ) {
        // First check if already compiled
        ruleStore.lookUpContentRuleList(forIdentifier: identifier) { [weak self] existingList, error in
            if let existingList = existingList {
                self?.loadedRuleLists[identifier] = existingList
                completion(.success(existingList))
                return
            }
            
            // Need to compile
            self?.ruleStore.compileContentRuleList(
                forIdentifier: identifier,
                encodedContentRuleList: jsonRules
            ) { [weak self] ruleList, error in
                if let ruleList = ruleList {
                    self?.loadedRuleLists[identifier] = ruleList
                    completion(.success(ruleList))
                } else if let error = error {
                    warn("ContentBlocker: Failed to compile \(identifier): \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let unknownError = NSError(
                        domain: "ContentBlocker",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Unknown compilation error"]
                    )
                    completion(.failure(unknownError))
                }
            }
        }
    }
    
    /// Compile a predefined rule set
    public func compileRuleSet(
        _ ruleSet: RuleSet,
        completion: @escaping (Result<WKContentRuleList, Error>) -> Void
    ) {
        compileRules(identifier: ruleSet.rawValue, jsonRules: ruleSet.jsonRules, completion: completion)
    }
    
    /// Compile rules from a bundle JSON file
    public func compileRulesFromBundle(
        _ basename: String,
        completion: @escaping (Result<WKContentRuleList, Error>) -> Void
    ) {
        guard let jsonUrl = Bundle.main.url(forResource: basename, withExtension: "json") else {
            let error = NSError(
                domain: "ContentBlocker",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "Could not find \(basename).json in bundle"]
            )
            completion(.failure(error))
            return
        }
        
        do {
            let jsonRules = try String(contentsOf: jsonUrl, encoding: .utf8)
            compileRules(identifier: basename, jsonRules: jsonRules, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    /// Apply a compiled rule list to a WKUserContentController
    public func applyRuleList(_ ruleList: WKContentRuleList, to contentController: WKUserContentController) {
        contentController.add(ruleList)
    }
    
    /// Apply a rule set to a content controller (compiles if needed)
    public func applyRuleSet(
        _ ruleSet: RuleSet,
        to contentController: WKUserContentController,
        completion: ((Bool) -> Void)? = nil
    ) {
        if let cachedList = loadedRuleLists[ruleSet.rawValue] {
            contentController.add(cachedList)
            completion?(true)
            return
        }
        
        compileRuleSet(ruleSet) { [weak self] result in
            switch result {
            case .success(let ruleList):
                contentController.add(ruleList)
                completion?(true)
            case .failure:
                completion?(false)
            }
        }
    }
    
    /// Apply multiple rule sets to a content controller
    public func applyRuleSets(
        _ ruleSets: [RuleSet],
        to contentController: WKUserContentController,
        completion: (([RuleSet: Bool]) -> Void)? = nil
    ) {
        let group = DispatchGroup()
        var results: [RuleSet: Bool] = [:]
        let lock = NSLock()
        
        for ruleSet in ruleSets {
            group.enter()
            applyRuleSet(ruleSet, to: contentController) { success in
                lock.lock()
                results[ruleSet] = success
                lock.unlock()
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion?(results)
        }
    }
    
    /// Remove a rule list from a content controller
    public func removeRuleList(identifier: String, from contentController: WKUserContentController) {
        if let ruleList = loadedRuleLists[identifier] {
            contentController.remove(ruleList)
        }
    }
    
    /// Remove a rule set from a content controller
    public func removeRuleSet(_ ruleSet: RuleSet, from contentController: WKUserContentController) {
        removeRuleList(identifier: ruleSet.rawValue, from: contentController)
    }
    
    /// Remove all rule lists from a content controller
    public func removeAllRuleLists(from contentController: WKUserContentController) {
        contentController.removeAllContentRuleLists()
    }
    
    /// Delete a compiled rule list from storage
    public func deleteCompiledRules(identifier: String, completion: ((Error?) -> Void)? = nil) {
        loadedRuleLists.removeValue(forKey: identifier)
        ruleStore.removeContentRuleList(forIdentifier: identifier) { error in
            if let error = error {
                warn("ContentBlocker: Failed to delete \(identifier): \(error.localizedDescription)")
            }
            completion?(error)
        }
    }
    
    /// Get all available rule list identifiers from storage
    public func getAvailableRuleListIdentifiers(completion: @escaping ([String]) -> Void) {
        ruleStore.getAvailableContentRuleListIdentifiers { identifiers in
            completion(identifiers ?? [])
        }
    }
    
    // MARK: - Convenience for MPWebView
    
    /// Enable default content blocking (ads + trackers) on a WebView configuration
    public func enableDefaultBlocking(
        on configuration: WKWebViewConfiguration,
        completion: ((Bool) -> Void)? = nil
    ) {
        applyRuleSets([.ads, .trackers], to: configuration.userContentController) { results in
            let allSuccess = results.values.allSatisfy { $0 }
            completion?(allSuccess)
        }
    }
    
    /// Enable full privacy mode (ads + trackers + cookies + social)
    public func enablePrivacyMode(
        on configuration: WKWebViewConfiguration,
        completion: ((Bool) -> Void)? = nil
    ) {
        applyRuleSets([.ads, .trackers, .cookies, .social], to: configuration.userContentController) { results in
            let allSuccess = results.values.allSatisfy { $0 }
            completion?(allSuccess)
        }
    }
}

// MARK: - Custom Rule Builder

@available(macOS 10.13, iOS 11, *)
public extension ContentBlocker {
    
    /// Builder for creating custom content blocking rules
    class RuleBuilder {
        private var rules: [[String: Any]] = []
        
        public init() {}
        
        /// Block URLs matching a pattern
        @discardableResult
        public func blockURL(_ pattern: String) -> RuleBuilder {
            rules.append([
                "trigger": ["url-filter": pattern],
                "action": ["type": "block"]
            ])
            return self
        }
        
        /// Block specific domains (third-party only)
        @discardableResult
        public func blockDomains(_ domains: [String], thirdPartyOnly: Bool = true) -> RuleBuilder {
            var trigger: [String: Any] = [
                "url-filter": ".*",
                "if-domain": domains
            ]
            if thirdPartyOnly {
                trigger["load-type"] = ["third-party"]
            }
            rules.append([
                "trigger": trigger,
                "action": ["type": "block"]
            ])
            return self
        }
        
        /// Hide elements matching a CSS selector
        @discardableResult
        public func hideElements(selector: String, onDomains: [String]? = nil) -> RuleBuilder {
            var trigger: [String: Any] = ["url-filter": ".*"]
            if let domains = onDomains {
                trigger["if-domain"] = domains
            }
            rules.append([
                "trigger": trigger,
                "action": [
                    "type": "css-display-none",
                    "selector": selector
                ]
            ])
            return self
        }
        
        /// Block cookies from specified domains
        @discardableResult
        public func blockCookies(fromDomains domains: [String]? = nil, thirdPartyOnly: Bool = true) -> RuleBuilder {
            var trigger: [String: Any] = ["url-filter": ".*"]
            if let domains = domains {
                trigger["if-domain"] = domains
            }
            if thirdPartyOnly {
                trigger["load-type"] = ["third-party"]
            }
            rules.append([
                "trigger": trigger,
                "action": ["type": "block-cookies"]
            ])
            return self
        }
        
        /// Whitelist (ignore previous rules) for specific patterns
        @discardableResult
        public func whitelist(_ pattern: String) -> RuleBuilder {
            rules.append([
                "trigger": ["url-filter": pattern],
                "action": ["type": "ignore-previous-rules"]
            ])
            return self
        }
        
        /// Build the JSON string
        public func build() throws -> String {
            let data = try JSONSerialization.data(withJSONObject: rules, options: .prettyPrinted)
            guard let json = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "RuleBuilder", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode rules"])
            }
            return json
        }
    }
}

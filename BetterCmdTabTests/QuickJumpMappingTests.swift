import Testing
@testable import BetterCmdTab

@Suite("Quick-jump mappings")
struct QuickJumpMappingTests {
    @Test func normalizesCaseAndWhitespace() throws {
        let mapping = try #require(QuickJumpMapping(bundleID: "com.apple.Safari", letter: " S "))
        #expect(mapping.letter == "s")
        #expect(mapping.dictionary == ["bundleID": "com.apple.Safari", "letter": "s"])
    }

    @Test func rejectsNonAsciiOrMultipleCharacters() {
        #expect(QuickJumpMapping(bundleID: "com.apple.Safari", letter: "ss") == nil)
        #expect(QuickJumpMapping(bundleID: "com.apple.Safari", letter: "é") == nil)
        #expect(QuickJumpMapping(bundleID: "", letter: "s") == nil)
    }

    @Test func normalizationKeepsFirstUniqueAppAndLetter() throws {
        let safari = try #require(QuickJumpMapping(bundleID: "com.apple.Safari", letter: "s"))
        let safariAgain = try #require(QuickJumpMapping(bundleID: "com.apple.Safari", letter: "v"))
        let slack = try #require(QuickJumpMapping(bundleID: "com.tinyspeck.slackmacgap", letter: "s"))
        let vscode = try #require(QuickJumpMapping(bundleID: "com.microsoft.VSCode", letter: "v"))
        #expect(Preferences.normalizeQuickJumpMappings([safari, safariAgain, slack, vscode]) == [safari, vscode])
    }

    @Test func vimNavigationSidelinesHJKLMappings() throws {
        let helium = try #require(QuickJumpMapping(bundleID: "net.imput.helium", letter: "h"))
        let safari = try #require(QuickJumpMapping(bundleID: "com.apple.Safari", letter: "s"))
        #expect(Preferences.quickJumpLetters([helium, safari], vimEnabled: true) == ["com.apple.Safari": "s"])
        #expect(Preferences.quickJumpLetters([helium, safari], vimEnabled: false)
            == ["net.imput.helium": "h", "com.apple.Safari": "s"])
    }

    @Test func freeLetterPrefersNameThenAlphabetThenNil() {
        #expect(QuickJumpMapping.freeLetter(name: "\u{C9}cran", used: ["e"]) == "c")
        #expect(QuickJumpMapping.freeLetter(name: "hjkl", used: ["h", "j", "k", "l"]) == "a")
        #expect(QuickJumpMapping.freeLetter(name: "", used: Set("abcdefghijklmnopqrstuvwxyz")) == nil)
    }
}

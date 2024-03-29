@testable import day07
import XCTest

final class day07Tests: XCTestCase {
    let queryColor = "shiny gold"

    func testPart1Sample() {
        let actual = day07.solvePart1(sampleInputPart1, queryColor: queryColor)
        let expected = 4
        XCTAssertEqual(actual, expected)
    }

    func testPart1Real() {
        let actual = day07.solvePart1(realInput, queryColor: queryColor)
        let expected = 139
        XCTAssertEqual(actual, expected)
    }

    func testPart2Sample() {
        let actual = day07.solvePart2(sampleInputPart2, queryColor: queryColor)
        let expected = 126
        XCTAssertEqual(actual, expected)
    }

    func testPart2Real() {
        let actual = day07.solvePart2(realInput, queryColor: queryColor)
        let expected = 58175
        XCTAssertEqual(actual, expected)
    }
}

// MARK: - Input

let sampleInputPart1 = """
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
"""

let sampleInputPart2 = """
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
"""

let realInput = """
muted lime bags contain 1 wavy lime bag, 1 vibrant green bag, 3 light yellow bags.
light red bags contain 2 clear indigo bags, 3 light lime bags.
wavy beige bags contain 4 faded chartreuse bags.
muted blue bags contain 3 mirrored tan bags.
vibrant cyan bags contain 4 drab beige bags, 4 vibrant maroon bags, 2 dull coral bags.
posh indigo bags contain 1 dim cyan bag, 4 striped violet bags, 2 posh olive bags.
dark black bags contain 5 dotted purple bags, 3 dotted orange bags, 5 shiny gold bags, 3 wavy brown bags.
dull teal bags contain 1 posh aqua bag.
dim aqua bags contain 3 muted indigo bags, 5 vibrant green bags, 3 dotted teal bags.
clear bronze bags contain 1 plaid gold bag, 4 pale tan bags, 1 light teal bag, 5 dim lavender bags.
shiny fuchsia bags contain 5 striped orange bags, 2 faded plum bags.
dim bronze bags contain 2 plaid tan bags, 4 muted green bags.
muted white bags contain 1 wavy black bag, 2 striped olive bags.
wavy maroon bags contain 3 striped magenta bags, 3 bright teal bags, 2 dark crimson bags.
muted beige bags contain 4 dull plum bags, 2 plaid fuchsia bags, 3 clear coral bags, 1 clear red bag.
drab chartreuse bags contain 2 dull gray bags, 2 striped olive bags, 2 dark aqua bags.
plaid turquoise bags contain 1 muted teal bag.
muted maroon bags contain 1 faded chartreuse bag, 1 wavy gray bag, 5 faded black bags, 2 posh tan bags.
muted bronze bags contain 1 muted white bag.
muted teal bags contain 1 striped beige bag.
faded indigo bags contain 5 mirrored green bags.
drab tan bags contain 4 dim lavender bags.
bright turquoise bags contain 2 pale olive bags, 4 posh salmon bags.
dull aqua bags contain 2 dark orange bags, 2 pale aqua bags, 1 faded plum bag.
striped coral bags contain 3 wavy purple bags, 2 dull gray bags.
muted chartreuse bags contain 3 dark purple bags, 2 posh gray bags.
wavy plum bags contain 2 dark lavender bags, 2 shiny turquoise bags, 5 wavy beige bags, 5 pale maroon bags.
vibrant maroon bags contain 1 light lime bag, 1 light silver bag, 5 bright orange bags, 2 shiny red bags.
mirrored purple bags contain 3 bright olive bags, 3 bright yellow bags, 5 muted white bags.
muted magenta bags contain 5 plaid indigo bags.
drab lavender bags contain 1 faded beige bag, 2 muted gray bags, 2 dotted purple bags.
plaid cyan bags contain 4 plaid violet bags, 5 posh chartreuse bags.
plaid aqua bags contain 2 wavy gray bags, 4 light fuchsia bags, 4 muted white bags.
wavy bronze bags contain 4 light bronze bags, 3 light tomato bags, 5 shiny tomato bags.
wavy aqua bags contain 4 plaid crimson bags, 3 muted brown bags, 1 pale tan bag.
bright violet bags contain 1 wavy tan bag, 4 light coral bags, 1 vibrant plum bag.
pale yellow bags contain 4 light lime bags, 2 striped violet bags, 1 plaid orange bag, 3 dull lavender bags.
plaid olive bags contain 1 mirrored magenta bag, 3 posh silver bags, 1 plaid brown bag.
wavy brown bags contain 4 shiny black bags, 3 wavy plum bags.
clear turquoise bags contain 5 dotted beige bags.
striped fuchsia bags contain 2 dim tan bags.
pale coral bags contain 1 plaid coral bag, 5 striped salmon bags.
plaid magenta bags contain 4 plaid aqua bags, 2 dim cyan bags, 2 vibrant teal bags.
dim beige bags contain 5 shiny gold bags, 2 wavy brown bags.
clear violet bags contain 2 striped silver bags.
light lime bags contain 5 muted teal bags.
pale plum bags contain 2 vibrant lavender bags.
drab black bags contain 3 light white bags, 2 dim tomato bags, 3 dull yellow bags, 2 plaid coral bags.
vibrant lime bags contain 5 wavy gray bags, 5 striped green bags, 5 striped black bags.
faded fuchsia bags contain 3 shiny aqua bags.
vibrant olive bags contain 2 striped olive bags.
dark indigo bags contain 5 pale maroon bags, 2 striped turquoise bags.
dark cyan bags contain 3 light gold bags, 1 plaid lime bag, 1 dim indigo bag.
clear tomato bags contain 3 plaid tan bags, 2 vibrant blue bags.
muted yellow bags contain 2 dotted coral bags.
muted brown bags contain 1 vibrant green bag, 3 bright green bags, 2 plaid fuchsia bags.
dark bronze bags contain 2 clear orange bags.
dotted turquoise bags contain 4 faded black bags, 3 plaid crimson bags, 3 faded beige bags.
shiny violet bags contain 4 muted blue bags, 2 light purple bags, 5 striped magenta bags, 3 dark black bags.
dotted orange bags contain 3 striped tan bags, 2 posh brown bags, 2 muted white bags, 5 dark crimson bags.
shiny gold bags contain 1 clear coral bag, 1 muted green bag, 5 muted teal bags, 4 dull olive bags.
clear brown bags contain 1 shiny tomato bag.
shiny beige bags contain 4 dotted chartreuse bags.
dotted tomato bags contain 5 dull aqua bags.
dull black bags contain 2 muted purple bags.
wavy turquoise bags contain 5 striped beige bags, 2 dark silver bags, 2 light beige bags, 5 dull olive bags.
bright coral bags contain 4 pale crimson bags, 4 striped coral bags, 3 drab cyan bags, 4 vibrant aqua bags.
mirrored salmon bags contain 1 wavy orange bag, 1 dark lime bag.
clear chartreuse bags contain 4 muted indigo bags, 5 dotted gray bags.
dim chartreuse bags contain 1 clear lime bag, 3 muted gray bags, 5 vibrant blue bags, 4 mirrored gold bags.
vibrant purple bags contain 4 dull brown bags, 5 clear aqua bags, 2 bright bronze bags, 5 shiny lavender bags.
pale turquoise bags contain 3 light black bags, 1 dim tan bag.
mirrored black bags contain 1 wavy beige bag.
striped white bags contain 4 dim chartreuse bags, 2 pale lime bags, 1 faded orange bag.
faded bronze bags contain 5 drab cyan bags.
dull coral bags contain 5 dull crimson bags, 3 plaid silver bags.
posh gray bags contain 4 muted indigo bags, 4 bright cyan bags, 1 faded black bag.
vibrant bronze bags contain 4 posh crimson bags, 4 mirrored silver bags, 1 dark turquoise bag, 1 pale maroon bag.
posh lavender bags contain 1 vibrant gold bag, 3 faded maroon bags, 4 striped magenta bags, 3 wavy gold bags.
clear olive bags contain 1 posh tomato bag, 2 clear lime bags, 1 plaid yellow bag.
bright orange bags contain 4 light aqua bags, 3 vibrant teal bags, 5 dull crimson bags, 3 dark fuchsia bags.
dotted lavender bags contain 1 posh beige bag, 5 faded cyan bags, 1 dark olive bag.
posh beige bags contain 3 dotted blue bags, 4 faded indigo bags.
dull indigo bags contain 4 clear green bags, 5 muted bronze bags.
mirrored brown bags contain 5 muted beige bags, 3 dull chartreuse bags, 4 shiny black bags, 1 dim green bag.
bright silver bags contain 3 clear white bags, 5 light tomato bags, 5 plaid blue bags.
dotted teal bags contain no other bags.
light brown bags contain 1 faded indigo bag, 3 dotted coral bags.
light indigo bags contain 1 plaid red bag, 5 vibrant magenta bags, 4 pale lavender bags.
drab beige bags contain 1 dotted gold bag, 3 clear black bags.
striped orange bags contain 3 shiny red bags, 4 striped olive bags, 1 posh maroon bag.
bright lavender bags contain no other bags.
clear yellow bags contain 5 mirrored green bags, 4 striped red bags, 3 plaid magenta bags, 1 bright lavender bag.
pale bronze bags contain 4 bright beige bags, 4 muted beige bags, 3 pale salmon bags.
light salmon bags contain 3 shiny brown bags.
shiny plum bags contain 5 dotted turquoise bags.
dotted red bags contain 2 muted bronze bags, 2 dull yellow bags, 4 drab turquoise bags.
faded white bags contain 1 striped beige bag.
bright olive bags contain 1 posh brown bag, 2 mirrored red bags.
light gray bags contain 5 wavy lavender bags, 5 vibrant yellow bags.
mirrored indigo bags contain 1 wavy turquoise bag, 5 muted green bags.
light black bags contain 3 light fuchsia bags, 3 plaid fuchsia bags, 5 mirrored green bags.
striped maroon bags contain 4 dull fuchsia bags, 1 striped olive bag, 1 mirrored gold bag, 4 light violet bags.
mirrored silver bags contain 2 posh tan bags, 2 mirrored magenta bags, 1 dark orange bag.
pale aqua bags contain 5 dim tan bags, 4 muted black bags.
pale gray bags contain 2 clear plum bags.
faded turquoise bags contain 5 faded black bags, 3 shiny black bags.
dotted indigo bags contain 4 plaid green bags, 4 dull brown bags, 1 plaid magenta bag, 2 plaid tomato bags.
vibrant silver bags contain 3 drab chartreuse bags.
dotted crimson bags contain 1 drab coral bag, 2 shiny red bags, 2 dotted plum bags, 4 mirrored yellow bags.
clear orange bags contain 4 wavy black bags, 2 drab coral bags, 1 bright lavender bag, 2 dull olive bags.
mirrored violet bags contain 4 striped tan bags.
bright tan bags contain 1 mirrored gold bag, 1 dotted turquoise bag, 4 wavy orange bags.
dull bronze bags contain 3 shiny chartreuse bags, 2 dark beige bags.
vibrant white bags contain 4 plaid tan bags, 1 wavy black bag.
wavy green bags contain 2 muted fuchsia bags, 3 plaid gold bags, 3 striped green bags, 5 dim cyan bags.
striped brown bags contain 3 vibrant olive bags, 2 plaid orange bags.
wavy lavender bags contain 2 muted orange bags, 4 clear maroon bags, 5 bright tomato bags.
bright purple bags contain 4 dim crimson bags.
pale fuchsia bags contain 5 bright lime bags.
posh aqua bags contain 5 clear lime bags, 1 shiny turquoise bag, 5 bright cyan bags, 2 dim chartreuse bags.
dark olive bags contain 5 shiny tan bags, 5 plaid red bags, 5 pale lavender bags.
striped silver bags contain 3 bright plum bags.
striped tomato bags contain 1 pale maroon bag, 1 clear yellow bag.
faded beige bags contain 1 light fuchsia bag.
plaid green bags contain 5 light fuchsia bags.
drab silver bags contain 4 vibrant white bags.
striped indigo bags contain 4 shiny green bags, 2 dark beige bags.
mirrored teal bags contain 3 muted green bags, 5 muted gray bags.
posh gold bags contain 3 wavy beige bags, 5 muted lavender bags, 1 striped tan bag.
wavy red bags contain 2 dim beige bags.
dull plum bags contain 2 drab coral bags, 3 wavy black bags.
bright crimson bags contain 2 posh silver bags, 3 vibrant plum bags, 5 posh brown bags.
clear gray bags contain 1 dotted white bag, 2 posh aqua bags.
striped aqua bags contain 1 muted black bag, 5 dim bronze bags, 3 striped olive bags, 1 plaid turquoise bag.
dark tomato bags contain 2 dull olive bags, 1 plaid aqua bag, 4 faded fuchsia bags, 4 muted gray bags.
vibrant yellow bags contain 5 dim blue bags, 5 dim crimson bags, 1 dotted aqua bag.
shiny salmon bags contain 4 bright lavender bags, 2 faded black bags, 5 mirrored salmon bags.
wavy salmon bags contain 1 plaid aqua bag, 2 mirrored fuchsia bags, 2 muted green bags.
faded cyan bags contain 5 plaid fuchsia bags, 4 dull gray bags.
clear coral bags contain 1 striped olive bag.
bright white bags contain 1 muted gray bag.
dim salmon bags contain 1 faded red bag, 2 striped plum bags.
dotted silver bags contain 5 faded lime bags, 2 drab black bags, 2 mirrored teal bags, 2 drab tomato bags.
bright teal bags contain 5 dotted gray bags.
faded red bags contain 3 light purple bags, 5 plaid yellow bags.
muted salmon bags contain 3 clear yellow bags.
shiny turquoise bags contain 2 dark lavender bags, 1 dark crimson bag.
muted indigo bags contain 4 dark lavender bags, 1 posh olive bag.
wavy gray bags contain no other bags.
muted olive bags contain 3 bright tomato bags, 4 plaid coral bags, 4 dull orange bags, 2 wavy brown bags.
clear black bags contain 1 dim chartreuse bag, 5 dark aqua bags, 5 dotted teal bags.
faded yellow bags contain 1 drab salmon bag, 1 bright lavender bag.
shiny yellow bags contain 3 dark olive bags, 1 bright tomato bag, 3 dim fuchsia bags.
clear blue bags contain 2 light coral bags, 2 faded beige bags, 4 muted indigo bags, 1 faded blue bag.
dim lime bags contain 5 striped tan bags, 4 light black bags, 1 dark orange bag.
wavy coral bags contain 2 mirrored black bags, 4 vibrant coral bags, 1 pale chartreuse bag.
wavy fuchsia bags contain 4 shiny silver bags.
dim silver bags contain 3 clear blue bags.
plaid chartreuse bags contain 2 clear plum bags.
pale blue bags contain 4 pale magenta bags.
drab red bags contain 3 plaid cyan bags, 3 light yellow bags.
dull gold bags contain 5 clear lime bags, 5 plaid coral bags.
shiny indigo bags contain 3 dim bronze bags, 5 dotted teal bags.
light purple bags contain 5 light lime bags, 1 shiny plum bag.
mirrored cyan bags contain 5 clear lime bags.
posh chartreuse bags contain 2 striped olive bags.
dark gray bags contain 5 vibrant maroon bags, 2 dark olive bags.
clear lavender bags contain 3 striped magenta bags, 3 pale lavender bags, 2 dotted chartreuse bags, 4 dim tan bags.
faded lavender bags contain 5 striped lavender bags, 2 mirrored yellow bags, 4 bright purple bags.
striped tan bags contain 3 drab coral bags, 3 vibrant indigo bags.
dim violet bags contain 4 wavy black bags, 3 faded indigo bags, 2 wavy gray bags, 5 striped red bags.
dotted magenta bags contain 5 shiny indigo bags, 3 mirrored red bags.
shiny blue bags contain 4 light tan bags, 4 striped black bags, 1 vibrant teal bag, 4 shiny gray bags.
bright gray bags contain 5 clear tomato bags, 5 dark lavender bags.
dark turquoise bags contain 5 dull lime bags, 3 dim green bags, 3 pale tan bags.
clear beige bags contain 3 drab aqua bags.
pale olive bags contain 4 dark green bags, 1 posh crimson bag.
posh fuchsia bags contain 3 dim green bags, 3 posh maroon bags, 1 posh olive bag, 4 muted fuchsia bags.
posh bronze bags contain 5 striped olive bags, 2 dark lavender bags, 4 posh tan bags.
shiny bronze bags contain 4 dotted plum bags, 4 clear indigo bags.
wavy magenta bags contain 2 dim chartreuse bags, 2 mirrored gold bags, 2 wavy gold bags.
dull yellow bags contain 4 plaid tan bags.
mirrored tomato bags contain 3 light violet bags.
light turquoise bags contain 3 bright yellow bags, 1 drab blue bag.
plaid maroon bags contain 2 plaid magenta bags.
pale silver bags contain 2 wavy bronze bags, 3 striped tan bags.
striped blue bags contain 1 dark crimson bag, 4 dull purple bags, 4 bright tomato bags.
faded blue bags contain 2 posh olive bags, 1 clear silver bag, 5 faded turquoise bags.
dark blue bags contain 5 vibrant gray bags, 3 pale lavender bags.
light fuchsia bags contain 1 dotted teal bag, 2 shiny red bags, 4 bright cyan bags.
dull chartreuse bags contain 5 dull olive bags, 2 dull gray bags.
pale orange bags contain 2 striped lavender bags, 3 dotted red bags.
dark silver bags contain 1 muted white bag, 3 striped aqua bags, 3 dim aqua bags, 2 striped tan bags.
dark lavender bags contain 3 wavy gray bags, 4 dim chartreuse bags, 1 bright lavender bag, 3 muted gray bags.
light beige bags contain 4 dim aqua bags, 5 mirrored teal bags.
plaid violet bags contain 2 clear plum bags, 2 striped olive bags.
plaid orange bags contain 1 dim maroon bag, 1 dim bronze bag, 5 muted white bags.
faded crimson bags contain 3 faded cyan bags.
muted plum bags contain 5 bright teal bags.
striped crimson bags contain 3 shiny violet bags, 4 striped beige bags, 5 wavy violet bags.
shiny lime bags contain 5 dim green bags, 5 mirrored black bags.
muted lavender bags contain 4 mirrored magenta bags, 4 wavy yellow bags, 5 pale gold bags, 2 light cyan bags.
drab aqua bags contain 3 plaid blue bags, 3 pale bronze bags, 3 bright magenta bags.
dark yellow bags contain 4 bright salmon bags, 2 dim yellow bags.
posh teal bags contain 1 clear crimson bag.
clear fuchsia bags contain 1 vibrant blue bag, 2 shiny lavender bags, 3 faded teal bags, 4 plaid green bags.
bright yellow bags contain 4 mirrored coral bags, 2 dull purple bags, 3 dim indigo bags, 5 dark white bags.
pale purple bags contain 2 vibrant olive bags, 1 dark fuchsia bag, 3 faded turquoise bags.
dotted coral bags contain 4 dark crimson bags.
plaid beige bags contain 2 striped maroon bags, 4 mirrored fuchsia bags, 5 shiny turquoise bags, 3 clear plum bags.
plaid white bags contain 5 posh chartreuse bags, 4 dark crimson bags.
shiny black bags contain 4 dim brown bags, 5 plaid tan bags, 5 plaid orange bags.
dim teal bags contain 1 wavy aqua bag.
dim yellow bags contain 2 muted bronze bags, 1 bright indigo bag.
dim tan bags contain 1 plaid turquoise bag, 4 vibrant plum bags, 2 plaid aqua bags.
bright salmon bags contain 3 dim blue bags, 5 wavy gray bags, 2 bright maroon bags.
posh plum bags contain 2 dark cyan bags, 1 bright orange bag, 1 dotted crimson bag, 4 dark tan bags.
muted crimson bags contain 1 striped beige bag, 4 muted salmon bags, 1 faded tan bag, 3 dull fuchsia bags.
mirrored lavender bags contain 3 light black bags, 4 posh salmon bags, 2 shiny black bags.
dim olive bags contain 2 bright green bags, 3 bright magenta bags, 4 striped silver bags, 1 vibrant indigo bag.
faded coral bags contain 5 posh blue bags, 5 dotted maroon bags, 3 dark maroon bags.
striped cyan bags contain 2 vibrant purple bags, 2 shiny silver bags, 5 clear tan bags, 4 muted orange bags.
striped beige bags contain 2 bright lavender bags, 3 mirrored gold bags, 4 dull fuchsia bags, 4 dull gray bags.
mirrored magenta bags contain 5 posh crimson bags, 1 pale magenta bag, 3 striped maroon bags, 4 shiny turquoise bags.
vibrant chartreuse bags contain 2 light beige bags, 4 dark white bags.
mirrored fuchsia bags contain 4 plaid red bags.
vibrant turquoise bags contain 4 light teal bags, 5 plaid salmon bags, 2 muted tan bags, 5 posh tomato bags.
faded gray bags contain 2 dull white bags, 1 plaid orange bag.
bright bronze bags contain 4 muted teal bags, 3 dark crimson bags, 4 posh tan bags.
plaid lime bags contain 3 striped turquoise bags.
pale teal bags contain 5 shiny silver bags, 4 posh plum bags, 3 plaid salmon bags.
dark chartreuse bags contain 5 bright plum bags, 2 faded beige bags, 1 vibrant chartreuse bag.
dull crimson bags contain 5 light beige bags, 4 muted purple bags, 4 dotted chartreuse bags, 4 faded turquoise bags.
dotted salmon bags contain 3 faded indigo bags, 1 dotted gold bag, 3 light lime bags.
bright black bags contain 2 dim yellow bags, 3 vibrant coral bags, 5 light coral bags.
plaid blue bags contain 4 mirrored tomato bags, 5 faded fuchsia bags, 5 dull chartreuse bags.
shiny white bags contain 4 dim maroon bags, 1 dim gray bag, 2 light white bags, 3 dull tan bags.
muted cyan bags contain 2 pale cyan bags.
dim red bags contain 1 faded indigo bag.
mirrored tan bags contain 4 striped magenta bags, 1 clear chartreuse bag.
bright blue bags contain 2 wavy turquoise bags.
pale tan bags contain 2 faded black bags.
dark green bags contain 1 pale salmon bag.
pale beige bags contain 2 bright chartreuse bags, 4 faded bronze bags.
dotted gold bags contain 2 wavy black bags, 1 dotted coral bag, 4 dim maroon bags, 5 dark green bags.
dark magenta bags contain 2 wavy yellow bags, 1 dark cyan bag.
bright chartreuse bags contain 4 dotted blue bags, 3 shiny aqua bags, 1 muted crimson bag, 4 dull blue bags.
dotted black bags contain 4 posh gray bags, 4 striped white bags, 2 faded green bags, 2 shiny indigo bags.
posh red bags contain 4 clear chartreuse bags, 4 plaid maroon bags, 2 striped orange bags.
dark aqua bags contain 1 vibrant indigo bag, 1 dark crimson bag.
drab indigo bags contain 2 vibrant salmon bags, 2 shiny purple bags.
dull lavender bags contain 4 vibrant plum bags, 3 vibrant indigo bags, 3 clear lime bags.
dull magenta bags contain 4 mirrored white bags, 3 clear olive bags, 5 striped plum bags.
dotted chartreuse bags contain 3 striped beige bags, 4 wavy gray bags.
dotted yellow bags contain 3 plaid white bags, 2 posh gray bags.
vibrant red bags contain 5 clear cyan bags.
dim orange bags contain 4 drab chartreuse bags, 3 muted teal bags.
shiny brown bags contain 3 dim maroon bags.
posh green bags contain 5 muted brown bags, 1 dark crimson bag.
pale lime bags contain 3 muted gray bags, 5 dotted coral bags, 5 faded black bags, 2 vibrant white bags.
dim maroon bags contain 2 wavy gray bags, 4 plaid fuchsia bags.
bright beige bags contain 3 striped maroon bags, 2 striped magenta bags, 3 light teal bags, 2 shiny red bags.
drab magenta bags contain 2 posh olive bags.
wavy white bags contain 3 plaid tomato bags, 1 dotted gray bag, 2 mirrored bronze bags.
posh coral bags contain 2 wavy coral bags, 5 mirrored tan bags, 1 pale gray bag.
plaid gray bags contain 3 faded green bags, 5 faded olive bags, 4 drab white bags, 3 wavy green bags.
bright plum bags contain 1 dark aqua bag, 4 shiny red bags, 2 vibrant white bags.
plaid tomato bags contain 2 light lime bags, 3 vibrant white bags.
pale brown bags contain 1 faded brown bag.
muted gray bags contain 3 posh olive bags, 4 plaid fuchsia bags, 3 vibrant blue bags.
dotted green bags contain 1 dim lavender bag, 4 striped chartreuse bags, 3 bright maroon bags.
striped yellow bags contain 4 pale white bags, 2 bright blue bags, 5 faded orange bags, 2 dull violet bags.
mirrored chartreuse bags contain 2 shiny indigo bags, 2 mirrored teal bags.
posh olive bags contain 4 muted purple bags, 1 dull gray bag, 1 striped beige bag.
posh salmon bags contain 5 dim yellow bags, 2 dark purple bags.
drab gold bags contain 3 posh white bags, 3 dotted salmon bags, 2 vibrant coral bags.
faded silver bags contain 2 wavy magenta bags.
dim blue bags contain 2 clear lime bags.
faded black bags contain 4 dark crimson bags, 2 dark aqua bags, 1 mirrored teal bag, 4 dull brown bags.
striped lavender bags contain 4 plaid red bags, 1 light black bag, 2 bright cyan bags, 2 muted tan bags.
mirrored olive bags contain 2 plaid beige bags, 1 wavy aqua bag, 3 faded tomato bags.
wavy lime bags contain 1 mirrored brown bag, 5 posh cyan bags.
dim crimson bags contain 2 drab chartreuse bags, 1 posh lavender bag.
dim black bags contain 2 dull black bags, 3 vibrant maroon bags, 2 light fuchsia bags.
drab cyan bags contain 3 striped turquoise bags.
dim brown bags contain 5 dim orange bags, 5 dull brown bags, 1 dotted teal bag, 3 dark white bags.
vibrant magenta bags contain 1 light crimson bag, 4 light maroon bags.
dotted fuchsia bags contain 1 dark green bag, 3 wavy gold bags, 3 bright indigo bags.
light crimson bags contain 2 pale chartreuse bags.
posh crimson bags contain 5 plaid tan bags, 1 dark lavender bag, 4 light lime bags.
dark fuchsia bags contain 5 mirrored coral bags, 5 vibrant olive bags, 4 light black bags.
faded chartreuse bags contain 3 drab coral bags, 1 dim chartreuse bag, 4 dotted chartreuse bags, 1 muted teal bag.
dotted lime bags contain 1 shiny turquoise bag, 3 vibrant plum bags, 5 vibrant teal bags.
light teal bags contain 3 bright plum bags.
shiny chartreuse bags contain 5 vibrant green bags, 1 dim blue bag.
vibrant tomato bags contain 1 clear tan bag, 3 faded magenta bags, 2 clear cyan bags, 2 dark silver bags.
posh cyan bags contain 1 vibrant white bag, 2 dull white bags, 3 drab coral bags.
dim white bags contain 5 shiny aqua bags, 2 shiny bronze bags, 1 plaid turquoise bag, 4 dull tomato bags.
vibrant plum bags contain 3 posh olive bags, 4 dark crimson bags, 3 mirrored gold bags.
clear cyan bags contain 5 shiny cyan bags, 2 clear fuchsia bags, 5 plaid lime bags, 1 muted green bag.
mirrored red bags contain 5 dotted coral bags, 3 shiny gold bags, 2 clear plum bags.
mirrored gray bags contain 3 clear black bags, 1 bright fuchsia bag, 1 drab teal bag, 5 faded bronze bags.
posh orange bags contain 2 bright cyan bags, 1 muted gray bag.
plaid salmon bags contain 5 dim maroon bags, 1 pale chartreuse bag, 3 posh fuchsia bags, 3 dark turquoise bags.
dull silver bags contain 2 mirrored maroon bags, 2 plaid lavender bags, 1 dotted red bag.
light plum bags contain 4 light white bags, 3 wavy lavender bags, 5 vibrant salmon bags.
dotted white bags contain 5 light aqua bags, 4 dim brown bags, 3 drab brown bags.
drab green bags contain 1 wavy black bag, 5 vibrant orange bags, 5 wavy orange bags, 1 muted purple bag.
pale red bags contain 3 dim tomato bags.
clear silver bags contain 3 clear lime bags.
faded gold bags contain 4 faded orange bags, 4 light bronze bags, 3 wavy gray bags.
drab tomato bags contain 3 clear black bags, 1 dark white bag, 5 light silver bags.
dull tomato bags contain 5 vibrant indigo bags, 5 dotted plum bags, 4 dull black bags.
light gold bags contain 2 bright gold bags, 5 faded white bags, 3 striped gold bags.
faded green bags contain 1 light purple bag.
striped gray bags contain 4 muted gray bags.
striped plum bags contain 2 dim coral bags.
dull olive bags contain 3 pale salmon bags.
bright tomato bags contain 2 dim bronze bags, 1 dim chartreuse bag, 5 clear purple bags.
wavy purple bags contain 2 faded green bags.
muted coral bags contain 1 faded black bag.
dark beige bags contain 3 mirrored gold bags, 4 posh brown bags, 1 dotted indigo bag, 3 mirrored fuchsia bags.
faded plum bags contain 5 dotted coral bags.
light maroon bags contain 3 striped violet bags.
wavy orange bags contain 3 plaid orange bags, 1 striped turquoise bag, 4 muted black bags, 2 posh indigo bags.
drab purple bags contain 4 dull lime bags, 4 posh lavender bags, 4 shiny green bags, 3 faded beige bags.
dim fuchsia bags contain 1 vibrant purple bag, 5 dim yellow bags.
plaid tan bags contain 5 posh maroon bags, 3 plaid crimson bags, 5 dim chartreuse bags.
light bronze bags contain 2 posh cyan bags, 5 shiny indigo bags, 1 faded silver bag, 5 shiny brown bags.
dotted gray bags contain 3 faded beige bags, 1 shiny turquoise bag.
dull white bags contain 3 muted indigo bags, 4 clear coral bags.
drab crimson bags contain 1 dark white bag, 1 wavy salmon bag.
clear maroon bags contain 1 shiny tan bag, 3 muted brown bags.
shiny green bags contain 2 drab black bags, 3 mirrored brown bags.
dark red bags contain 4 faded white bags, 5 faded plum bags.
dim purple bags contain 5 wavy maroon bags, 1 pale bronze bag.
shiny coral bags contain 1 dull olive bag, 2 wavy tomato bags, 3 dark tomato bags, 2 drab lime bags.
muted fuchsia bags contain 3 faded beige bags.
plaid silver bags contain 5 mirrored violet bags, 5 dark tomato bags.
vibrant gold bags contain 5 striped turquoise bags, 4 shiny gray bags, 2 muted maroon bags, 5 dark orange bags.
bright fuchsia bags contain 4 pale red bags, 3 posh fuchsia bags.
dark violet bags contain 4 drab yellow bags.
dim gold bags contain 5 vibrant silver bags.
posh tomato bags contain 1 mirrored violet bag.
drab yellow bags contain 1 light silver bag, 4 clear maroon bags, 5 dotted aqua bags, 1 posh maroon bag.
vibrant lavender bags contain 4 dim turquoise bags.
dotted blue bags contain 3 faded black bags.
plaid crimson bags contain 5 wavy gray bags, 3 striped beige bags.
dim green bags contain 2 bright cyan bags, 4 bright beige bags.
faded brown bags contain 4 posh cyan bags.
muted violet bags contain 4 posh aqua bags, 4 bright yellow bags, 2 drab red bags, 3 dull teal bags.
shiny silver bags contain 5 plaid fuchsia bags.
wavy olive bags contain 4 light brown bags, 4 shiny turquoise bags, 1 bright orange bag, 5 drab blue bags.
mirrored turquoise bags contain 1 dark lime bag, 1 faded bronze bag, 1 dark lavender bag, 3 wavy turquoise bags.
dark lime bags contain 3 dim bronze bags, 5 shiny turquoise bags, 1 muted gray bag.
striped gold bags contain 3 faded turquoise bags, 5 striped teal bags, 4 posh lavender bags.
light orange bags contain 5 wavy beige bags.
muted tomato bags contain 1 striped red bag.
dull blue bags contain 1 plaid aqua bag, 3 dull coral bags, 5 posh yellow bags.
dark plum bags contain 4 bright lavender bags, 4 dull black bags, 4 clear silver bags, 2 faded fuchsia bags.
light tomato bags contain 1 plaid white bag, 5 muted purple bags.
wavy tomato bags contain 4 vibrant teal bags, 1 plaid green bag, 1 dotted gold bag.
pale white bags contain 3 plaid tomato bags, 3 muted green bags, 4 light black bags.
vibrant fuchsia bags contain 1 shiny salmon bag, 3 faded red bags, 4 faded gray bags, 4 drab turquoise bags.
clear red bags contain 2 vibrant olive bags.
dull violet bags contain 5 dim indigo bags.
posh silver bags contain 1 drab tomato bag.
dark white bags contain 5 vibrant green bags, 3 mirrored gold bags, 2 striped beige bags.
mirrored maroon bags contain 1 muted teal bag, 1 muted indigo bag.
wavy cyan bags contain 2 striped silver bags.
plaid purple bags contain 2 posh olive bags, 3 vibrant salmon bags, 1 bright silver bag.
dull maroon bags contain 5 plaid fuchsia bags, 1 striped gray bag.
dark gold bags contain 5 light red bags, 4 plaid indigo bags, 1 dim aqua bag, 5 dark lavender bags.
plaid brown bags contain 3 shiny purple bags, 4 mirrored lime bags, 3 dark white bags.
dotted tan bags contain 4 striped olive bags.
shiny purple bags contain 5 faded indigo bags, 2 dim tan bags.
clear lime bags contain no other bags.
posh turquoise bags contain 4 drab gray bags, 5 plaid crimson bags, 4 striped silver bags.
dotted brown bags contain 3 dotted gold bags.
striped violet bags contain 2 dull white bags.
striped green bags contain 4 clear aqua bags, 4 posh tan bags.
pale tomato bags contain 5 dark maroon bags, 4 faded indigo bags, 4 dull turquoise bags, 1 bright tomato bag.
plaid coral bags contain 4 dark tomato bags, 1 pale purple bag, 1 faded tan bag, 5 dim tan bags.
shiny cyan bags contain 2 shiny magenta bags, 1 dark lavender bag, 2 vibrant blue bags.
light yellow bags contain 1 muted brown bag.
dark orange bags contain 2 dim brown bags, 5 light beige bags, 4 clear orange bags, 3 dotted blue bags.
drab violet bags contain 1 light turquoise bag.
wavy silver bags contain 3 bright magenta bags, 2 clear salmon bags.
clear magenta bags contain 3 shiny black bags, 3 dim brown bags, 4 dim indigo bags.
drab maroon bags contain 5 posh maroon bags, 3 clear orange bags, 3 dotted coral bags.
muted silver bags contain 3 vibrant magenta bags, 4 shiny lavender bags, 5 posh crimson bags.
pale gold bags contain 1 light white bag, 5 plaid chartreuse bags, 4 striped magenta bags.
muted turquoise bags contain 1 mirrored turquoise bag.
faded violet bags contain 5 shiny indigo bags.
clear crimson bags contain 1 faded gray bag, 5 vibrant silver bags, 5 plaid blue bags, 1 muted fuchsia bag.
vibrant aqua bags contain 3 dotted chartreuse bags.
posh brown bags contain 2 bright cyan bags, 3 shiny gold bags.
faded magenta bags contain 3 wavy yellow bags, 4 clear orange bags.
posh maroon bags contain 5 striped beige bags.
dotted violet bags contain 4 wavy gold bags.
shiny red bags contain 1 posh olive bag, 1 vibrant green bag, 4 muted purple bags.
posh blue bags contain 3 mirrored coral bags, 1 shiny white bag, 1 dotted salmon bag, 5 vibrant silver bags.
striped teal bags contain 1 striped turquoise bag, 1 faded black bag, 1 muted green bag.
wavy blue bags contain 4 dull lavender bags, 4 vibrant orange bags, 2 plaid white bags, 5 muted indigo bags.
clear gold bags contain 4 bright silver bags, 2 clear red bags, 4 dim aqua bags, 5 dim crimson bags.
shiny magenta bags contain 3 plaid violet bags, 4 dotted lime bags.
bright indigo bags contain 1 muted green bag.
clear white bags contain 2 vibrant chartreuse bags, 4 drab coral bags, 4 bright cyan bags.
clear aqua bags contain 1 bright lavender bag, 5 mirrored brown bags, 2 drab green bags, 5 muted maroon bags.
posh magenta bags contain 4 posh salmon bags, 3 dull crimson bags, 5 wavy violet bags, 4 bright purple bags.
plaid indigo bags contain 4 dull maroon bags.
pale magenta bags contain 5 light black bags.
plaid red bags contain 3 mirrored gold bags, 5 light tomato bags, 2 wavy violet bags.
striped olive bags contain 4 posh maroon bags, 4 wavy black bags, 4 striped beige bags.
drab blue bags contain 4 faded black bags, 3 dark indigo bags, 4 dim violet bags.
plaid bronze bags contain 3 vibrant orange bags, 3 dark aqua bags.
vibrant blue bags contain no other bags.
dark tan bags contain 5 mirrored tomato bags.
dotted purple bags contain 4 muted brown bags, 2 striped orange bags, 1 dark green bag.
mirrored white bags contain 1 clear red bag.
posh lime bags contain 2 posh crimson bags.
shiny orange bags contain 1 dark fuchsia bag.
faded olive bags contain 4 vibrant teal bags.
dull purple bags contain 3 wavy orange bags, 4 dim brown bags, 5 shiny olive bags, 2 bright beige bags.
dark coral bags contain 4 pale lime bags, 2 posh cyan bags.
pale violet bags contain 4 bright tomato bags, 5 mirrored black bags, 4 vibrant gold bags.
light coral bags contain 5 drab magenta bags, 2 mirrored tomato bags, 1 muted orange bag, 5 clear maroon bags.
pale green bags contain 2 dim aqua bags, 4 dark fuchsia bags, 2 drab salmon bags.
plaid gold bags contain 3 dotted lime bags, 3 faded indigo bags, 5 striped turquoise bags, 5 plaid chartreuse bags.
dull orange bags contain 4 mirrored coral bags, 3 dotted maroon bags, 5 striped orange bags, 3 light green bags.
shiny olive bags contain 4 muted purple bags, 4 plaid aqua bags, 3 dotted blue bags, 5 dotted teal bags.
dim coral bags contain 2 light purple bags, 1 striped beige bag, 4 striped indigo bags.
mirrored gold bags contain 1 vibrant blue bag, 1 dotted teal bag, 1 pale salmon bag, 3 wavy gray bags.
dim turquoise bags contain 1 vibrant orange bag.
dark teal bags contain 4 dark chartreuse bags, 5 mirrored cyan bags.
light silver bags contain 5 striped red bags, 3 dim bronze bags.
light blue bags contain 1 light beige bag, 3 posh tomato bags.
posh violet bags contain 2 faded maroon bags, 5 pale plum bags, 1 dotted teal bag, 3 dotted coral bags.
plaid teal bags contain 1 dotted chartreuse bag, 4 posh turquoise bags, 3 pale blue bags.
faded lime bags contain 5 mirrored gold bags, 2 plaid fuchsia bags.
faded aqua bags contain 4 dark tomato bags, 3 posh olive bags, 4 mirrored black bags, 1 wavy salmon bag.
mirrored beige bags contain 1 striped lavender bag.
vibrant indigo bags contain 3 plaid fuchsia bags, 1 bright lavender bag.
wavy tan bags contain 5 drab coral bags, 5 posh tomato bags, 4 light fuchsia bags, 3 striped tan bags.
shiny crimson bags contain 2 drab olive bags, 5 bright chartreuse bags, 3 faded magenta bags, 5 mirrored salmon bags.
dim tomato bags contain 3 pale tan bags, 5 dotted maroon bags.
clear indigo bags contain 2 dotted gray bags, 5 clear lime bags, 1 muted teal bag, 1 plaid green bag.
vibrant brown bags contain 1 vibrant beige bag.
dotted cyan bags contain 1 muted fuchsia bag, 4 faded olive bags, 4 mirrored lime bags.
mirrored crimson bags contain 2 dark indigo bags, 4 light coral bags, 5 dark silver bags.
dim indigo bags contain 1 plaid fuchsia bag.
shiny teal bags contain 4 shiny turquoise bags.
striped lime bags contain 1 clear purple bag, 3 pale bronze bags, 2 vibrant orange bags.
light tan bags contain 1 wavy gold bag, 1 light fuchsia bag.
clear green bags contain 1 faded olive bag, 2 vibrant coral bags.
wavy black bags contain 5 dotted teal bags, 3 dull fuchsia bags.
wavy crimson bags contain 5 shiny teal bags, 5 drab teal bags.
shiny tomato bags contain 4 clear chartreuse bags, 5 muted teal bags, 3 posh maroon bags.
dotted plum bags contain 4 dark chartreuse bags, 5 plaid orange bags.
dull beige bags contain 5 dim lavender bags, 3 plaid magenta bags, 4 dotted tan bags.
drab teal bags contain 3 posh silver bags, 1 shiny cyan bag, 1 bright teal bag.
faded orange bags contain 1 dark lime bag.
pale cyan bags contain 4 vibrant aqua bags.
striped red bags contain 5 dull fuchsia bags, 2 clear plum bags.
mirrored green bags contain 3 plaid orange bags, 3 dim aqua bags.
faded tomato bags contain 4 dim plum bags.
clear salmon bags contain 4 dim beige bags, 4 clear beige bags, 4 drab salmon bags, 2 dull turquoise bags.
vibrant tan bags contain 2 wavy gold bags, 1 plaid tan bag, 1 wavy bronze bag, 4 dull tomato bags.
vibrant salmon bags contain 1 plaid violet bag, 5 plaid green bags, 4 dark white bags, 2 muted white bags.
light chartreuse bags contain 3 dull cyan bags, 2 mirrored fuchsia bags.
mirrored bronze bags contain 4 plaid white bags, 1 drab salmon bag.
dull fuchsia bags contain no other bags.
mirrored lime bags contain 4 dotted orange bags, 5 faded tan bags, 4 faded silver bags, 5 plaid salmon bags.
dotted aqua bags contain 3 plaid green bags.
drab brown bags contain 4 dotted turquoise bags, 1 plaid orange bag, 2 striped silver bags.
posh black bags contain 5 faded turquoise bags, 2 dark lime bags.
light violet bags contain 1 bright lavender bag, 4 plaid crimson bags.
drab fuchsia bags contain 1 shiny beige bag, 3 dull tan bags, 3 shiny brown bags.
dotted bronze bags contain 4 light tomato bags, 2 light blue bags, 1 faded lavender bag, 5 bright cyan bags.
bright cyan bags contain 4 dull olive bags.
pale maroon bags contain 4 dim aqua bags.
bright magenta bags contain 3 striped beige bags, 3 shiny gray bags, 4 clear plum bags.
pale crimson bags contain 5 dim blue bags, 2 dotted fuchsia bags, 2 shiny plum bags, 1 muted fuchsia bag.
vibrant teal bags contain 5 dull gray bags, 5 drab coral bags, 3 clear orange bags.
dotted maroon bags contain 1 muted white bag, 2 dim orange bags, 4 vibrant blue bags.
vibrant green bags contain 3 plaid tan bags, 4 muted gray bags.
plaid lavender bags contain 1 pale gold bag, 2 shiny brown bags.
plaid plum bags contain 5 light salmon bags, 2 clear indigo bags, 2 faded bronze bags, 2 drab violet bags.
posh white bags contain 2 dark purple bags, 2 faded plum bags.
striped chartreuse bags contain 4 dark turquoise bags, 4 light beige bags, 4 vibrant purple bags, 3 bright bronze bags.
dim gray bags contain 4 light black bags, 1 plaid fuchsia bag.
clear teal bags contain 1 dotted fuchsia bag, 4 dark silver bags, 1 dark purple bag, 5 light aqua bags.
clear tan bags contain 3 clear red bags.
clear purple bags contain 3 plaid orange bags, 2 muted brown bags.
vibrant coral bags contain 5 dull olive bags, 2 vibrant maroon bags.
dim plum bags contain 2 faded salmon bags, 5 dark green bags.
dim cyan bags contain 3 plaid fuchsia bags, 4 dark crimson bags, 2 muted indigo bags, 2 pale lime bags.
striped magenta bags contain 1 clear orange bag, 5 dotted gray bags, 2 wavy gray bags.
dotted beige bags contain 4 shiny bronze bags, 4 drab white bags, 4 plaid indigo bags, 2 plaid gold bags.
dull green bags contain 2 faded salmon bags, 5 vibrant lavender bags, 4 clear gold bags.
light aqua bags contain 2 bright lavender bags, 4 shiny gray bags.
drab orange bags contain 2 pale red bags, 4 vibrant bronze bags, 4 dim purple bags.
posh yellow bags contain 4 wavy bronze bags, 2 light coral bags, 1 faded chartreuse bag.
drab coral bags contain 4 mirrored gold bags, 2 plaid tan bags, 2 wavy black bags, 2 striped beige bags.
muted purple bags contain no other bags.
bright lime bags contain 3 dotted violet bags, 2 dotted teal bags, 3 bright gray bags.
muted black bags contain 2 posh orange bags, 1 bright bronze bag, 1 clear lime bag.
dotted olive bags contain 1 vibrant violet bag, 5 clear green bags, 4 posh tomato bags.
striped bronze bags contain 4 pale teal bags, 1 faded yellow bag, 5 dull yellow bags.
light magenta bags contain 1 muted green bag, 5 dim plum bags, 2 bright tan bags, 1 plaid indigo bag.
pale lavender bags contain 3 dotted blue bags.
faded tan bags contain 1 light lime bag, 1 faded black bag, 2 light fuchsia bags.
mirrored coral bags contain 5 dark white bags, 4 dark orange bags, 5 faded black bags.
drab salmon bags contain 2 dark turquoise bags, 3 wavy plum bags, 4 dotted chartreuse bags, 5 light beige bags.
muted aqua bags contain 3 light beige bags.
light cyan bags contain 1 shiny coral bag, 5 vibrant silver bags.
drab turquoise bags contain 1 striped aqua bag, 1 drab lime bag.
wavy indigo bags contain 2 clear salmon bags, 1 dotted silver bag.
shiny tan bags contain 2 faded fuchsia bags, 3 faded black bags.
shiny gray bags contain 5 pale salmon bags, 4 shiny gold bags.
vibrant black bags contain 3 wavy orange bags, 3 light purple bags, 4 mirrored turquoise bags, 4 drab tomato bags.
dull gray bags contain no other bags.
dark salmon bags contain 3 striped silver bags, 4 clear indigo bags.
plaid black bags contain 3 dim cyan bags, 2 bright beige bags.
wavy gold bags contain 4 drab coral bags, 4 vibrant teal bags, 4 clear orange bags, 2 wavy black bags.
light lavender bags contain 4 bright plum bags, 3 light violet bags, 2 muted purple bags, 4 posh orange bags.
dark crimson bags contain 1 plaid tan bag, 2 muted gray bags, 5 dotted teal bags.
bright maroon bags contain 4 striped red bags, 4 drab maroon bags, 3 bright magenta bags.
dark purple bags contain 1 clear plum bag, 1 dotted gold bag.
dull salmon bags contain 2 faded salmon bags.
vibrant orange bags contain 5 posh olive bags, 4 dim cyan bags, 5 striped beige bags, 2 vibrant chartreuse bags.
dark maroon bags contain 1 posh brown bag, 3 dotted maroon bags.
vibrant crimson bags contain 3 plaid white bags, 1 clear chartreuse bag, 5 pale bronze bags, 4 dotted brown bags.
mirrored orange bags contain 2 pale coral bags, 1 faded indigo bag, 2 dull red bags, 1 light tan bag.
bright red bags contain 2 striped red bags, 5 posh tan bags.
faded purple bags contain 2 plaid aqua bags.
muted green bags contain 2 mirrored gold bags, 3 vibrant indigo bags, 1 dotted teal bag, 3 striped tan bags.
mirrored plum bags contain 2 wavy fuchsia bags, 1 faded turquoise bag, 5 dim purple bags.
dull brown bags contain 2 striped tan bags, 3 vibrant blue bags, 4 vibrant white bags, 5 dim chartreuse bags.
faded salmon bags contain 5 light red bags, 4 pale indigo bags, 2 posh bronze bags, 1 dull turquoise bag.
posh purple bags contain 3 shiny lime bags.
muted tan bags contain 5 dark lime bags, 3 wavy tomato bags, 2 bright teal bags.
dull cyan bags contain 3 vibrant green bags, 3 bright maroon bags.
drab white bags contain 4 wavy black bags.
striped black bags contain 1 posh tan bag, 5 clear orange bags.
mirrored yellow bags contain 4 plaid turquoise bags, 3 drab silver bags, 1 dull tomato bag.
dull red bags contain 4 wavy olive bags.
drab gray bags contain 2 striped maroon bags, 2 striped gray bags, 3 drab cyan bags.
faded teal bags contain 1 bright bronze bag, 5 clear tomato bags, 5 dim orange bags, 4 dim chartreuse bags.
muted orange bags contain 1 wavy maroon bag, 4 bright tomato bags, 1 light white bag, 2 dotted coral bags.
drab plum bags contain 2 muted lavender bags, 2 shiny magenta bags, 5 posh red bags, 2 bright fuchsia bags.
faded maroon bags contain 4 wavy tomato bags, 1 dull brown bag, 4 striped maroon bags, 3 posh aqua bags.
muted red bags contain 3 dull tomato bags.
mirrored aqua bags contain 5 posh tomato bags, 4 muted teal bags, 5 drab green bags.
dark brown bags contain 4 vibrant aqua bags.
plaid fuchsia bags contain no other bags.
posh tan bags contain 4 clear plum bags, 2 posh orange bags, 5 wavy gray bags.
striped turquoise bags contain 4 dark aqua bags.
drab lime bags contain 5 posh brown bags, 5 muted indigo bags, 2 dotted maroon bags, 2 clear lime bags.
wavy teal bags contain 2 mirrored red bags, 1 bright lavender bag, 5 dotted crimson bags, 4 faded beige bags.
shiny lavender bags contain 5 clear purple bags, 4 dim indigo bags, 4 shiny plum bags, 1 dull white bag.
dull lime bags contain 1 dim aqua bag, 1 shiny magenta bag.
shiny maroon bags contain 5 posh red bags, 5 dim coral bags, 4 clear crimson bags, 2 bright lime bags.
vibrant gray bags contain 2 plaid cyan bags, 4 plaid lime bags.
bright brown bags contain 1 drab lavender bag, 1 dim fuchsia bag, 4 dim olive bags, 3 wavy purple bags.
bright green bags contain 5 shiny red bags, 3 vibrant olive bags, 3 muted teal bags.
vibrant beige bags contain 4 clear olive bags, 5 striped black bags.
drab olive bags contain 1 vibrant white bag, 5 drab brown bags, 5 faded chartreuse bags, 5 dark lime bags.
wavy chartreuse bags contain 1 dull gray bag, 1 dull lavender bag, 1 mirrored green bag, 2 muted maroon bags.
pale indigo bags contain 5 bright beige bags, 4 dull crimson bags.
dull tan bags contain 5 bright lavender bags, 4 bright cyan bags, 2 dim maroon bags.
vibrant violet bags contain 4 dim violet bags.
pale salmon bags contain no other bags.
shiny aqua bags contain 2 plaid crimson bags, 2 mirrored red bags.
pale black bags contain 1 wavy chartreuse bag.
drab bronze bags contain 5 clear aqua bags, 3 pale brown bags.
light white bags contain 1 light tan bag, 3 dotted maroon bags.
light green bags contain 3 wavy olive bags.
wavy yellow bags contain 3 faded white bags, 5 wavy plum bags, 1 shiny turquoise bag.
wavy violet bags contain 2 pale salmon bags.
striped salmon bags contain 5 light turquoise bags, 4 muted tan bags.
muted gold bags contain 5 vibrant coral bags.
clear plum bags contain 4 vibrant green bags.
striped purple bags contain 1 posh red bag, 3 clear olive bags.
dim lavender bags contain 5 wavy plum bags.
bright gold bags contain 3 wavy brown bags, 2 mirrored magenta bags, 2 drab coral bags.
plaid yellow bags contain 2 plaid aqua bags, 4 pale salmon bags.
mirrored blue bags contain 4 posh orange bags.
dull turquoise bags contain 5 light teal bags, 5 striped green bags.
bright aqua bags contain 4 dotted lime bags.
light olive bags contain 3 wavy lavender bags, 5 wavy teal bags.
pale chartreuse bags contain 4 dark lime bags, 3 dim orange bags, 5 dotted maroon bags.
dim magenta bags contain 1 dark maroon bag, 3 dull olive bags, 5 dim tomato bags, 5 wavy gold bags.
"""

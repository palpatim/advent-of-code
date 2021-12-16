import XCTest
@testable import day16

final class day16Tests: XCTestCase {

    func testParsing() {
        let hexString = "D2FE28"
        let packet = BITSPacket.from(hexString: hexString)

        XCTAssertEqual(packet.version, 6)
        XCTAssertEqual(packet.packetTypeID, 4)
        XCTAssertEqual(packet.evaluate(), 2021)
    }

    func testPart1Sample() {
        var input: String!
        var result: BITSPacket!

        input = "D2FE28"
        result = day16.solve(input)
        XCTAssertEqual(result.versionSum(), 6)

        input = "8A004A801A8002F478"
        result = day16.solve(input)
        XCTAssertEqual(result.versionSum(), 16)

        input = "EE00D40C823060"
        result = day16.solve(input)
        XCTAssertEqual(result.versionSum(), 14)

        input = "620080001611562C8802118E34"
        result = day16.solve(input)
        XCTAssertEqual(result.versionSum(), 12)

        input = "C0015000016115A2E0802F182340"
        result = day16.solve(input)
        XCTAssertEqual(result.versionSum(), 23)

        input = "A0016C880162017C3686B18A3D4780"
        result = day16.solve(input)
        XCTAssertEqual(result.versionSum(), 31)
    }

    func testPart1Real() {
        let result = day16.solve(realInput)
        XCTAssertEqual(result.versionSum(), 906)
    }

    func testPart2Sample() {
        var input: String!
        var result: BITSPacket!

        input = "D2FE28"
        result = day16.solve(input)
        XCTAssertEqual(result.evaluate(), 2021)

        input = "C200B40A82"
        result = day16.solve(input)
        XCTAssertEqual(result.evaluate(), 3)

        input = "04005AC33890"
        result = day16.solve(input)
        XCTAssertEqual(result.evaluate(), 54)

        input = "880086C3E88112"
        result = day16.solve(input)
        XCTAssertEqual(result.evaluate(), 7)

        input = "CE00C43D881120"
        result = day16.solve(input)
        XCTAssertEqual(result.evaluate(), 9)

        input = "D8005AC2A8F0"
        result = day16.solve(input)
        XCTAssertEqual(result.evaluate(), 1)

        input = "F600BC2D8F"
        result = day16.solve(input)
        XCTAssertEqual(result.evaluate(), 0)

        input = "9C005AC2F8F0"
        result = day16.solve(input)
        XCTAssertEqual(result.evaluate(), 0)

        input = "9C0141080250320F1802104A08"
        result = day16.solve(input)
        XCTAssertEqual(result.evaluate(), 1)
    }

    func testPart2Real() {
        let result = day16.solve(realInput)
        XCTAssertEqual(result.evaluate(), 819324480368)
    }

}

// MARK: - Input

let realInput = """
020D790050D26C13EC1348326D336ACE00EC299E6A8B929ED59C880502E00A526B969F62BF35CB4FB15B93A6311F67F813300470037500043E2D4218FA000864538E905A39CAF77386E35AB01802FC01BA00021118617C1F00043A3F4748A53CF66008D00481272D73308334EDB0ED304E200D4E94CF612A49B40036C98A7CF24A53CA94C6370FBDCC9018029600ACD529CA9A4F62ACD2B5F928802F0D2665CA7D6CC013919E78A3800D3CF7794A8FC938280473057394AFF15099BA23CDD37A08400E2A5F7297F916C9F97F82D2DFA734BC600D4E3BC89CCBABCBE2B77D200412599244D4C0138C780120CC67E9D351C5AB4E1D4C981802980080CDB84E034C5767C60124F3BC984CD1E479201232C016100662D45089A00087C1084F12A724752BEFEA9C51500566759BF9BE6C5080217910CD00525B6350E8C00E9272200DCE4EF4C1DD003952F7059BCF675443005680103976997699795E830C02E4CBCE72EFC6A6218C88C9DF2F3351FCEF2D83CADB779F59A052801F2BAACDAE7F52A8190073937FE1D700439234DBB4F7374DC0CC804CF1006A0D47B8A4200F445865170401F8251662D100909401AB8803313217C680004320D43F871308D140C010E0069E7EDD1796AFC8255800052E20043E0F42A8B6400864258E51088010B85910A0F4ECE1DFE069C0229AE63D0B8DC6F82529403203305C00E1002C80AF5602908400A20240100852401E98400830021400D30029004B6100294008400B9D0023240061C000D19CACCD9005F694AEF6493D3F9948DEB3B4CC273FFD5E9AD85CFDFF6978B80050392AC3D98D796449BE304FE7F0C13CD716656BD0A6002A67E61A400F6E8029300B300B11480463D004C401889B1CA31800211162204679621200FCAC01791CF6B1AFCF2473DAC6BF3A9F1700016A3D90064D359B35D003430727A7DC464E6401594A57C93A0084CC56A662B8C00AA424989F2A9112
"""

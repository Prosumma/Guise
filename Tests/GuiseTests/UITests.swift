import Foundation
import Guise
import Testing

@Test func testUI() async throws {
  let container = Container()
  container.register(lifetime: .singleton) { r, u in
    MainActor.assumeIsolated {
      UI(x: u)
    }
  }
  try await MainActor.run {
    let ui1: UI = try container.resolve(args: UUID())
    let ui2: UI = try container.resolve()
    #expect(ui1 === ui2)
  }
}

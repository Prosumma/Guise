import Foundation

@MainActor
class UI {
  let x: UUID

  init(x: UUID? = nil) {
    self.x = x ?? UUID()
  }
}
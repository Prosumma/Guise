import Foundation

@MainActor
class UI { // swiftlint:disable:this type_name
  let x: UUID

  init(x: UUID? = nil) {
    self.x = x ?? UUID()
  }
}

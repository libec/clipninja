@testable import ClipNinja

struct TestViewPortConfiguration: ViewPortConfiguration {
    var totalPages: Int = 9
    var defaultSelectedPage: Int = 0
    var clipsPerPage: Int = 9
}

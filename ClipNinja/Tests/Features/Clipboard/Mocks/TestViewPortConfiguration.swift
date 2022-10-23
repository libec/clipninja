@testable import ClipNinjaPackage

struct TestViewPortConfiguration: ViewPortConfiguration {
    var totalPages: Int = 9
    var defaultSelectedPage: Int = 0
    var clipsPerPage: Int = 9
}

struct ViewPortConfigurationStub: ViewPortConfiguration {
    var defaultSelectedPage: Int = 0

    let totalPages: Int
    let clipsPerPage: Int

    init(totalPages: Int, clipsPerPage: Int) {
        self.totalPages = totalPages
        self.clipsPerPage = clipsPerPage
    }
}

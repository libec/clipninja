protocol ViewPortConfiguration {
    var totalPages: Int { get }
    var defaultSelectedPage: Int { get }
    var clipsPerPage: Int { get }
}

struct DefaultViewPortConfiguration: ViewPortConfiguration {
    let totalPages = 9
    let defaultSelectedPage = 0
    let clipsPerPage = 8
}

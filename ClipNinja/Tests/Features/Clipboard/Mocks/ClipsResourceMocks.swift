@testable import ClipNinjaPackage
import Combine

typealias ClipsResourceDummy = ClipsResourceSpy

class ClipsResourceSpy: ClipsResource {

    var clips: [Clip] = []
    var persistedClips: [Clip]? = nil

    func persist(clips: [Clip]) {
        persistedClips = clips
    }
}


class ClipsResourceStub: ClipsResourceSpy {

    init(clips: [Clip]) {
        super.init()
        self.clips = clips
    }
}

@testable import ClipNinjaPackage
import Combine

typealias ClipsStorageDummy = ClipsStorageSpy

class ClipsStorageSpy: ClipsStorage {

    var clips: [Clip] = []
    var persistedClips: [Clip]? = nil

    func persist(clips: [Clip]) {
        persistedClips = clips
    }
}


class ClipsStorageStub: ClipsStorageSpy {

    init(clips: [Clip]) {
        super.init()
        self.clips = clips
    }
}

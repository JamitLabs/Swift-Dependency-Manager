import Foundation
import Clibgit2

final class Git {
    // MARK: - Git Initialization
    static let shared = Git()

    private init() {
        git_libgit2_init()
    }

    // MARK: - Sub Types
    struct Repository {
        /// libgit2 pointer to repository
        private let pointer: UnsafeMutablePointer<OpaquePointer?>

        fileprivate init(remoteUrl: URL, localUrl: URL) {
            self.pointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
            git_clone(pointer, remoteUrl.absoluteString, localUrl.path, nil)
        }

        func tags() -> [String] {
            var tags = git_strarray()
            defer { git_strarray_free(&tags) }

            git_tag_list(&tags, pointer.pointee);
            return git_strarray_to_strings(&tags)
        }

        func commitOID(forTag tag: String) -> OID {
            let tagPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
            git_reference_lookup(tagPointer, pointer.pointee, "refs/tags/\(tag)")
            return OID(withGitOid: git_tag_target_id(tagPointer.pointee)!.pointee) // TODO: fix getting commit OID using tag name
        }
    }

    // MARK: - Git Tasks
    func clone(from remoteUrl: URL, to localUrl: URL) -> Repository {
        return Repository(remoteUrl: remoteUrl, localUrl: localUrl)
    }
}

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

        fileprivate init(remoteUrl: URL, localUrl: URL, branch: String?) {
            let cloneOptions = UnsafeMutablePointer<git_clone_options>.allocate(capacity: 1)
            git_clone_init_options(cloneOptions, UInt32(GIT_CLONE_OPTIONS_VERSION))

            if let branch = branch {
                cloneOptions.pointee.checkout_branch = (branch as NSString).utf8String
            }

            self.pointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
            git_clone(pointer, remoteUrl.absoluteString, localUrl.path, cloneOptions)
        }

        func tags() -> [String] {
            var tags = git_strarray()
            defer { git_strarray_free(&tags) }

            git_tag_list(&tags, pointer.pointee);
            return git_strarray_to_strings(&tags)
        }

        func commitOID(forBranch branch: String) -> OID {
            let branchPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
            git_branch_lookup(branchPointer, pointer.pointee, branch, git_convert_branch_type(BranchType.local))

            let commitPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
            git_reference_peel(commitPointer, branchPointer.pointee, GIT_OBJ_COMMIT)

            let commitGitOid = git_commit_id(commitPointer.pointee)
            return OID(withGitOid: commitGitOid!.pointee)
        }

        func commitOID(forTag tag: String) -> OID {
            let tagPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
            git_reference_lookup(tagPointer, pointer.pointee, "refs/tags/\(tag)")

            let commitPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
            git_reference_peel(commitPointer, tagPointer.pointee, GIT_OBJ_COMMIT)

            let commitGitOid = git_commit_id(commitPointer.pointee)
            return OID(withGitOid: commitGitOid!.pointee)
        }
    }

    // MARK: - Git Tasks
    func clone(from remoteUrl: URL, to localUrl: URL, branch: String?) -> Repository {
        return Repository(remoteUrl: remoteUrl, localUrl: localUrl, branch: branch)
    }
}

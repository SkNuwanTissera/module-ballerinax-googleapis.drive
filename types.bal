public type DriveInfo record {|
    string kind = "";
    // User user = [];
    // StorageQuota storageQuota = {};
    // ImportFormats importFormats = {};
    // ExportFormats exportFormats = {};
    // MaxImportSizes maxImportSizes = {};
    // long maxUploadSize = 0;
    // boolean appInstalled = false;
    // FolderColorPalette folderColorPalette = [];
    // TeamDriveThemes teamDriveThemes = [];
    // DriveThemes driveThemes = [];
    // boolean canCreateTeamDrives = false;
    // boolean canCreateDrives = false;

|};

public type File record {|
    string kind;
    string id;
    string name;
    string mimeType;
    string description?;
    boolean starred?;
    boolean trashed?;
    boolean explicitlyTrashed?;
    User trashingUser?;
    string trashedTime?;
    string[] parents?;
    string properties?;
    string appProperties?;
    string[] spaces?;
    int 'version?;
    string webContentLink?;
    string webViewLink?;
    string iconLink?;
    boolean hasThumbnail?;
    string thumbnailLink?;
    int thumbnailVersion?;
    string viewedByMe?;
    string viewedByMeTime?;
    string createdTime?;
    string modifiedTime?;
    string modifiedByMeTime?;
    string sharedWithMeTime?;
    User sharingUser?;
    User[] owners?;
    string teamDriveId?;
    string driveId?;
    User lastModifyingUser?;
    boolean shared?;
    boolean ownedByMe?;
    Capabilities capabilities?;

|};

public type FilesResponse record {|
    string kind;
    string nextPageToken?;
    boolean incompleteSearch;
    File[] files;
|};

public type GetFileOptional record {|
    boolean? acknowledgeAbuse = ();
    string? fields = ();
    string? includePermissionsForView = ();
    boolean? supportsAllDrives = ();
|};

public type User record {|
    string kind;
    string displayName;
    string photoLink;
    boolean me;
    string permissionId;
    string emailAddress;
|};

public type Capabilities record {|
    boolean	canAddChildren;
    boolean canAddFolderFromAnotherDrive;
    boolean canAddMyDriveParent;
    boolean canChangeCopyRequiresWriterPermission;
    boolean canChangeViewersCanCopyContent;
    boolean canComment;
    boolean canCopy;
    boolean canDelete;
    boolean canDeleteChildren;
    boolean canDownload;
    boolean canEdit;
    boolean canListChildren;
    boolean canModifyContent;
    boolean canModifyContentRestriction;
    boolean canMoveChildrenOutOfTeamDrive;
    boolean canMoveChildrenOutOfDrive;
    boolean canMoveChildrenWithinTeamDrive;
    boolean canMoveChildrenWithinDrive;
    boolean canMoveItemIntoTeamDrive;
    boolean canMoveItemOutOfTeamDrive;
    boolean canMoveItemOutOfDrive;
    boolean canMoveItemWithinTeamDrive;
    boolean canMoveItemWithinDrive;
    boolean canMoveTeamDriveItem;
    boolean canReadRevisions;
    boolean canReadTeamDrive;
    boolean canReadDrive;
    boolean canRemoveChildren;
    boolean canRemoveMyDriveParent;
    boolean canRename;
    boolean canShare;
    boolean canTrash;
    boolean canTrashChildren;
    boolean canUntrash;
|};
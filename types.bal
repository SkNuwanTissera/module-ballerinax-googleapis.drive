public type DriveInfo record {
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

};

public type File record {
    string kind?;
    string id?; 
    string name?;
    string mimeType?;
    string description?;
    boolean starred?;
    boolean trashed?;
    boolean explicitlyTrashed?;
    User trashingUser?;
    string trashedTime?;
    string[] parents?;
    StringKeyValuePairs properties?;
    StringKeyValuePairs appProperties?;
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
    boolean viewersCanCopyContent?;
    boolean copyRequiresWriterPermission?;
    boolean writersCanShare?;
    Permissions[] permissions?;
    string[] permissionIds?;
    boolean hasAugmentedPermissions?;
    string folderColorRgb?;
    string originalFilename?;
    string fullFileExtension?;
    string fileExtension?;
    string md5Checksum?;
    int size?; 
    int quotaBytesUsed?;
    string headRevisionId?;
    ContentHints contentHints?;
    ImageMediaMetadata imageMediaMetadata?;
    VideoMediaMetadata videoMediaMetadata?;
    boolean isAppAuthorized?;
    StringKeyValuePairs exportLinks?;
    ShortcutDetails shortcutDetails?;
    ContentRestrictions contentRestrictions?;

};

public type StringKeyValuePairs record {|
    string...;
|};

public type ContentRestrictions record {
    boolean readOnly?;
    string reason?;
    User restrictingUser?;
    string restrictionTime?;
    string 'type?;
};

public type ShortcutDetails record {
    string targetId;
    string targetMimeType;
};

public type VideoMediaMetadata record {
    int width;
    int height;
    float durationMillis;
};

public type ImageMediaMetadata record {
    int width;
    int height;
    int rotation;
    Location location;
    string time;
    string cameraMake;
    string cameraModel;
    int exposureTime;
    int aperture;
    boolean flashUsed;
    int focalLength;
    int isoSpeed;
    string meteringMode;
    string sensor;
    string exposureMode;
    string colorSpace;
    string whiteBalance;
    int exposureBias;
    int maxApertureValue;
    int subjectDistance;
    string lens;
};

public type Location record {
    int latitude; //double in API spec
    int longitude; //double in API spec
    int altitude; //double in API spec
};

public type ContentHints record {
    Thumbnail thumbnail;
    string indexableText;
};

public type Thumbnail record {
    byte image;
    string mimeType;
};

public type FilesResponse record {
    string kind;
    string nextPageToken?;
    boolean incompleteSearch;
    File[] files;
};

public type GetFileOptional record {
    boolean? acknowledgeAbuse = ();
    string? fields = ();
    string? includePermissionsForView = ();
    boolean? supportsAllDrives = ();
};

public type DeleteFileOptional record {
    boolean? supportsAllDrives = ();
};

public type CopyFileOptional record {
    string? fields = ();
    boolean? ignoreDefaultVisibility = ();
    string? includePermissionsForView = ();
    boolean? keepRevisionForever = ();
    string? ocrLanguage = ();
    boolean? supportsAllDrives = ();
};

public type UpdateFileOptional record {
   string uploadType; // use enum/finitetype UpdateType uploadType;
   string? addParents = (); 
   string? includePermissionsForView = (); 
   boolean? keepRevisionForever = (); 
   string? ocrLanguage = (); 
   string? removeParents = (); 
   boolean? supportsAllDrives = (); 
   boolean? useContentAsIndexableText = (); 
};

public type User record {
    string kind;
    string displayName;
    string photoLink;
    boolean me;
    string permissionId;
    string emailAddress;
};

public type Capabilities record {
    // consider 
    // boolean...s
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
};

public type Permissions record {
    string kind;
    string id;
    string 'type;
    string emailAddress;
    string domain;
    string role;
    string view;
    boolean allowFileDiscovery;
    string displayName;
    string photoLink;
    string expirationTime;
    TeamDrivePermissionDetails[] teamDrivePermissionDetails?;
    PermissionDetails[] permissionDetails?;
    boolean deleted;

};

public type TeamDrivePermissionDetails record {
    string teamDrivePermissionType;
    string role;
    string inheritedFrom;
    boolean inherited;
};

public type PermissionDetails record {
    string permissionType;
    string role;
    string inheritedFrom;
    boolean inherited;
};


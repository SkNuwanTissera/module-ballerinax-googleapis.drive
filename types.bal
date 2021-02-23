// Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

public type DriveInfo record {
    string kind?;
    User user?;
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
    float latitude; 
    float longitude; 
    float altitude;
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

public type CreateFileOptional record {
    never uploadType?; 
    boolean? ignoreDefaultVisibility = ();
    string? includePermissionsForView = (); 
    boolean? keepRevisionForever = (); 
    string? ocrLanguage = ();  
    boolean? supportsAllDrives = (); 
    boolean? useContentAsIndexableText = (); 
};

public type UpdateFileMetadataOptional record {
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

enum UploadTypes {
    SIMPLE = "media",
    MULTIPART = "multipart",
    RESUMABLE = "resumable"
}

public type ListFilesOptional record {
    string? corpora = (); 
    string? driveId = ();
    string? fields = (); 
    boolean? includeItemsFromAllDrives = (); 
    string? includePermissionsForView = ();  
    string? orderBy = (); 
    int? pageSize = (); 
    string? pageToken = ();
    string? q = ();
    string? spaces = ();
    boolean? supportsAllDrives = ();
};

public type WatchFileOptional record {
    boolean? acknowledgeAbuse = ();
    string? fields = ();
    boolean? supportsAllDrives = ();
};

public type FileWatchResource record {
    string? kind = ();
    string id;
    string? resourceId = ();
    string? resourceUri = ();
    string? token = ();
    float? expiration = ();
    string 'type;
    string address;
    boolean? payload = ();
    StringKeyValuePairs params?;
};



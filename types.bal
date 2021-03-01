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

# Drive Info Record Type
#
# + kind - Identifies what kind of resource this is. Value: the fixed string "drive#about".  
# + user - The authenticated user.  
public type DriveInfo record {
    string kind?;
    User user?;
};

# File Record Type
#
# + modifiedTime - The last time the file was modified by anyone (RFC 3339 date-time).  
# + copyRequiresWriterPermission - Whether the options to copy, print, or download this file, should be disabled for readers and commenters 
# + owners - The owners of the file. Currently, only certain legacy files may have more than one owner. Not populated for items in shared drives.  
# + mimeType - The MIME type of the file.Google Drive will attempt to automatically detect an appropriate value 
#              from uploaded content if no value is provided. The value cannot be changed unless a new revision is uploaded.
#              If a file is created with a Google Doc MIME type, the uploaded content will be imported if possible. 
#              The supported import formats are published in the About resource.  
# + contentRestrictions - Restrictions for accessing the content of the file. Only populated if such a restriction exists.  
# + version - A monotonically increasing version number for the file. This reflects every change made to the file on the server, 
# even those not visible to the user.  
# + iconLink - A static, unauthenticated link to the file's icon. 
# + starred - Whether the user has starred the file.  
# + permissions - The full list of permissions for the file. This is only available if the requesting user can share the file. 
#                 Not populated for items in shared drives. 
# + contentHints - Additional information about the content of the file. These fields are never populated in responses  
# + isAppAuthorized - Whether the file was created or opened by the requesting app.  
# + createdTime - The time at which the file was created (RFC 3339 date-time).  
# + id - The ID of the file/folder.  
# + sharedWithMeTime - The time at which the file was shared with the user, if applicable (RFC 3339 date-time).  
# + writersCanShare - Whether users with only writer permission can modify the file's permissions. Not populated for items in shared drives.  
# + kind - Identifies what kind of resource this is. Value: the fixed string "drive#file".   
# + webViewLink - A link for opening the file in a relevant Google editor or viewer in a browser. 
# + ownedByMe - Whether the user owns the file. Not populated for items in shared drives.  
# + explicitlyTrashed - Whether the file has been explicitly trashed, as opposed to recursively trashed from a parent folder.  
# + trashedTime - The time that the item was trashed (RFC 3339 date-time). Only populated for items in shared drives.  
# + viewedByMe - Whether the file has been viewed by this user.  
# + driveId - ID of the shared drive the file resides in. Only populated for items in shared drives  
# + size - The size of the file's content in bytes. This is applicable to binary files in Google Drive and Google Docs files.  
# + name - The name of the file. This is not necessarily unique within a folder. Note that for immutable items such as the 
#          top level folders of shared drives, My Drive root folder, and Application Data folder the name is constant.  
# + spaces - The list of spaces which contain the file. The currently supported values are 'drive', 'appDataFolder' and 'photos'.  
# + imageMediaMetadata - Additional metadata about image media, if available.  
# + trashed - Whether the file has been trashed, either explicitly or from a trashed parent folder. Only the owner may trash a file. 
#             The trashed item is excluded from all files.list responses returned for any user who does not own the file. 
#             However, all users with access to the file can see the trashed item metadata in an API response. 
#             All users with access can copy, download, export, and share the file.  
# + parents -  The IDs of the parent folders which contain the file. If not specified as part of a create request, the file will be placed 
#              directly in the user's My Drive folder. If not specified as part of a copy request, the file will inherit any discoverable 
#              parents of the source file. Update requests must use the addParents and removeParents parameters to modify the parents list.
# + appProperties - A collection of arbitrary key-value pairs which are private to the requesting app.  
# + folderColorRgb - The color for a folder as an RGB hex string. The supported colors are published in the folderColorPalette field of the About resource.  
# + headRevisionId - The ID of the file's head revision. This is currently only available for files with binary content in Google Drive.  
# + modifiedByMeTime - The last time the file was modified by the user (RFC 3339 date-time).  
# + shared - Whether the file has been shared. Not populated for items in shared drives.  
# + hasAugmentedPermissions - Whether there are permissions directly on this file. This field is only populated for items in shared drives.  
# + description - A short description of the file.  
# + trashingUser - If the file has been explicitly trashed, the user who trashed it. Only populated for items in shared drives.  
# + thumbnailLink - A short-lived link to the file's thumbnail, if available. Typically lasts on the order of hours. Only populated when the requesting 
#                   app can access the file's content. If the file isn't shared publicly, the URL returned in Files.thumbnailLink must be fetched using 
#                   a credentialed request.  
# + permissionIds - List of permission IDs for users with access to this file.  
# + quotaBytesUsed - The number of storage quota bytes used by the file. This includes the head revision as well as previous 
#                    revisions with keepForever enabled.  
# + lastModifyingUser - The last user to modify the file.  
# + md5Checksum - The MD5 checksum for the content of the file. This is only applicable to files with binary content in Google Drive.  
# + fileExtension - The final component of fullFileExtension. This is only available for files with binary content in Google Drive.  
# + fullFileExtension - The full file extension extracted from the name field. May contain multiple concatenated extensions, such as "tar.gz".
#                       This is only available for files with binary content in Google Drive.  
# + webContentLink - A link for downloading the content of the file in a browser. This is only available for files with binary content in Google Drive.  
# + shortcutDetails - Shortcut file details. Only populated for shortcut files, which have the mimeType field set to application/vnd.google-apps.shortcut  
# + hasThumbnail - Whether this file has a thumbnail. This does not indicate whether the requesting app has access to the thumbnail. To check access, 
#                  look for the presence of the thumbnailLink field.  
# + capabilities - Capabilities the current user has on this file. Each capability corresponds to a fine-grained action that a user may take.  
# + viewedByMeTime - The last time the file was viewed by the user (RFC 3339 date-time).  
# + videoMediaMetadata - Additional metadata about video media. This may not be available immediately upon upload.  
# + thumbnailVersion - The thumbnail version for use in thumbnail cache invalidation.  
# + exportLinks - Links for exporting Docs Editors files to specific formats.  
# + sharingUser - The user who shared the file with the requesting user, if applicable.  
# + properties - A collection of arbitrary key-value pairs which are visible to all apps.  
# + originalFilename - The original filename of the uploaded content if available, or else the original value of the name field. 
#                      This is only available for files with binary content in Google Drive  
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
    string driveId?;
    User lastModifyingUser?;
    boolean shared?;
    boolean ownedByMe?;
    Capabilities capabilities?;
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

# Restrictions for accessing the content of the file. Only populated if such a restriction exists.
#
# + reason - Reason for why the content of the file is restricted. This is only mutable on requests that also set readOnly=true.  
# + readOnly - Whether the content of the file is read-only. If a file is read-only, a new revision of the file may not be added,
#              comments may not be added or modified, and the title of the file may not be modified.  
# + restrictionTime - The time at which the content restriction was set (formatted RFC 3339 timestamp). Only populated if readOnly is true.  
# + type - The type of the content restriction. Currently the only possible value is globalContentRestriction.  
# + restrictingUser - The user who set the content restriction. Only populated if readOnly is true.  
public type ContentRestrictions record {
    boolean readOnly?;
    string reason?;
    User restrictingUser?;
    string restrictionTime?;
    string 'type?;
};

# Shortcut file details. Only populated for shortcut files, which have the mimeType field set to application/vnd.google-apps.shortcut.
#
# + targetId - The ID of the file that this shortcut points to.  
# + targetMimeType - The MIME type of the file that this shortcut points to. 
#                    The value of this field is a snapshot of the target's MIME type, captured when the shortcut is created.  
public type ShortcutDetails record {
    string targetId;
    string targetMimeType;
};

# Additional metadata about video media. This may not be available immediately upon upload.
#
# + width - The width of the video in pixelsn  
# + durationMillis - The duration of the video in milliseconds.  
# + height - The height of the video in pixels.  
public type VideoMediaMetadata record {
    int width;
    int height;
    float durationMillis;
};

# Additional metadata about image media, if available.
#
# + meteringMode -  The metering mode used to create the photo. 
# + exposureTime -  The length of the exposure, in seconds.
# + whiteBalance -  The white balance mode used to create the photo
# + rotation -  The number of clockwise 90 degree rotations applied from the image's original orientation. 
# + maxApertureValue -  The smallest f-number of the lens at the focal length used to create the photo (APEX value).
# + lens -  The lens used to create the photo.
# + exposureBias -  The exposure bias of the photo (APEX value)
# + colorSpace -   The color space of the photo
# + aperture -   The aperture used to create the photo (f-number).
# + flashUsed -  Whether a flash was used to create the photo. 
# + subjectDistance -  The distance to the subject of the photo, in meters.
# + width -  The width of the video in pixels.  
# + cameraModel -  The model of the camera used to create the photo. 	
# + location -  Geographic location information stored in the image.
# + isoSpeed -  The ISO speed used to create the photo.  
# + sensor -   The type of sensor used to create the photo
# + time -  The date and time the photo was taken (EXIF DateTime). 
# + cameraMake -   The make of the camera used to create the photo.
# + exposureMode -   The length of the exposure, in seconds.
# + height -   The height of the image in pixels.
# + focalLength -    The focal length used to create the photo, in millimeters.
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

# Geographic location information stored in the image.
#
# + altitude - The altitude stored in the image.  
# + latitude - The latitude stored in the image  
# + longitude - The longitude stored in the image.  
public type Location record {
    float latitude; 
    float longitude; 
    float altitude;
};

# Additional information about the content of the file. These fields are never populated in responses.
#
# + thumbnail - A thumbnail for the file. This will only be used if Google Drive cannot generate a standard thumbnail.  
# + indexableText - Text to be indexed for the file to improve fullText queries. This is limited to 128KB in length and may contain HTML elements.  
public type ContentHints record {
    Thumbnail thumbnail;
    string indexableText;
};

# A thumbnail for the file. This will only be used if Google Drive cannot generate a standard thumbnail.
#
# + image - The thumbnail data encoded with URL-safe Base64 (RFC 4648 section 5). 
# + mimeType - The MIME type of the thumbnail.  
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
    string? pageToken = (); //added external to API doc
};

public type FileWatchResource record {
    string kind?;
    string id?;
    string resourceId?;
    string resourceUri?;
    string token?;
    float expiration?;
    string 'type?;
    string address?;
    boolean payload?;
    StringKeyValuePairs params?;
};



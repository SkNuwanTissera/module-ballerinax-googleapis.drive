// Client Class

import ballerina/http;
import ballerina/oauth2;

public client class Client {

    public http:Client httpClient;

    public function init(DriveConfiguration driveConfig) {
        oauth2:OutboundOAuth2Provider oauth2Provider = new (driveConfig.oauth2Config);
        http:BearerAuthHandler bearerHandler = new (oauth2Provider);
        http:ClientSecureSocket? socketConfig = driveConfig?.secureSocketConfig;
        self.httpClient = new (DRIVE_URL, {
            auth: {
                authHandler: bearerHandler
            },
            secureSocket: socketConfig,
            http1Settings: {chunking: http:CHUNKING_NEVER}
        });

    }

    remote function getAbout(string? fields) returns @tainted json|error {
        return getDriveInfo(self.httpClient , fields);
    }

    remote function getFileById(string fileId, GetFileOptional? optional = ()) returns @tainted File|error {
        return getFileById(self.httpClient , fileId, optional);
    }

    remote function deleteFileById(string fileId, DeleteFileOptional? optional = ()) returns @tainted json|error{
        return deleteFileById(self.httpClient, fileId, optional);
    }

    remote function copyFile(string fileId, CopyFileOptional? optional = (), File? fileResource = ()) returns @tainted File|error{
        return copyFile(self.httpClient, fileId, optional, fileResource);
    }

    remote function updateFileMetadataById(string fileId, UpdateFileMetadataOptional? optional = (), File? fileResource = ()) returns @tainted File|error{
        return updateFileById(self.httpClient, fileId, optional, fileResource);
    }

    remote function updateExistingFile(string fileId, UpdateFileMetadataOptional? optional = (), File? fileResource = ()) returns @tainted File|error{
        return updateExistingFileById(self.httpClient, fileId, optional, fileResource);
    }

    remote function createMetaDataFile(CreateFileOptional? optional = (), File? fileData = ()) returns @tainted File|error{
        return createMetaDataFile(self.httpClient, optional, fileData);
    }

    remote function uploadFile(string filePath, UpdateFileMetadataOptional? optional = (), File? fileMetadata = ()) returns @tainted File|error{
        return uploadFile(self.httpClient, filePath, optional, fileMetadata);
    }

    remote function getFiles(ListFilesOptional? optional = ()) returns @tainted stream<File>|error {
        return getFiles(self.httpClient, optional);
    }
} 

public type DriveConfiguration record {
    oauth2:DirectTokenConfig oauth2Config;
    http:ClientSecureSocket secureSocketConfig?;
};


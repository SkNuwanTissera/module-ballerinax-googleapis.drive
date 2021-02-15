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
            secureSocket: socketConfig
        });

    }

    remote function getAbout(string? fields) returns @tainted json|error {
        return getDriveInfo(self.httpClient , fields);
    }

    remote function getFileById(string fileId, GetFileOptional? optional = ()) returns @tainted File|error {
        return getFileById(self.httpClient , fileId, optional);
    }

    remote function getFileByPath(string filePath, GetFileOptional? optional = ()) returns @tainted File|error {
        return getFileById(self.httpClient , check getIdFromUrl(filePath), optional);
    }

    remote function getFiles() returns @tainted stream<File>|error {
        return getAllFiles(self.httpClient);
    }

    remote function createFile(json? requestBody = ()) returns @tainted File|error{
        return createNewFile(self.httpClient, requestBody);
    }

    remote function deleteFileById(string fileId, DeleteFileOptional? optional = ()) returns @tainted json|error{
        return deleteFileById(self.httpClient, fileId, optional);
    }

    remote function deleteFileByPath(string filePath, DeleteFileOptional? optional = ()) returns @tainted json|error{
        return deleteFileById(self.httpClient, check getIdFromUrl(filePath), optional);
    }

    remote function copyFile(string fileId, CopyFileOptional? optional = (), File? fileResource = ()) returns @tainted File|error{
        return copyFile(self.httpClient, fileId, optional, fileResource);
    }

    remote function updateFile(string fileId, UpdateFileOptional? optional = (), File? fileResource = ()) returns @tainted File|error{
        return updateFile(self.httpClient, fileId, optional, fileResource);
    }
} 

public type DriveConfiguration record {
    oauth2:DirectTokenConfig oauth2Config;
    http:ClientSecureSocket secureSocketConfig?;
};


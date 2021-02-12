// Client Class

import ballerina/http;
import ballerina/oauth2;
import ballerina/log;

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

    //partially implemented
    remote function getFileByPath(string filePath, GetFileOptional? optional = ()) returns @tainted File|error {
        return getFileById(self.httpClient , check getIdFromUrl(filePath), optional);
    }

    remote function getFiles() returns @tainted stream<File>|error {
        return getAllFiles(self.httpClient);
    }

    remote function getFiles() returns @tainted stream<File>|error {
        return getAllFiles(self.httpClient);
    }

}

public type DriveConfiguration record {
    oauth2:DirectTokenConfig oauth2Config;
    http:ClientSecureSocket secureSocketConfig?;
};


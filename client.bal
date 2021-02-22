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

import ballerina/http;
import ballerina/oauth2;

public client class Client {

    public http:Client httpClient;

    Configuration driveConfiguration;

    public function init(Configuration driveConfig) {
        
        self.driveConfiguration = driveConfig;

        http:ClientSecureSocket? socketConfig = driveConfig?.secureSocketConfig;

        self.httpClient = checkpanic new (driveConfig.baseUrl, {
            auth: driveConfig.clientConfig,
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

public type Configuration record {
    string baseUrl;
    oauth2:DirectTokenConfig clientConfig;
    http:ClientSecureSocket secureSocketConfig?;
};


// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

//API URLs
const string BASE_URL = "https://sheets.googleapis.com";
public const string REFRESH_URL = "https://www.googleapis.com/oauth2/v3/token";

//Secure client configs
const string SCHEME = "oauth";

// URL encoding
const string ENCODING_CHARSET = "utf-8";

//Symbols
const string QUESTION_MARK = "?";
const string PATH_SEPARATOR = "/";
const string EMPTY_STRING = "";
const string WHITE_SPACE = " ";
const string FORWARD_SLASH = "/";
const string DASH_WITH_WHITE_SPACES_SYMBOL = " - ";
const string COLON = ":";
const string EXCLAMATION_MARK = "!";
const string EQUAL = "=";
const string _ALL = "*";

// Regex constants
const string _FILE = "/file/";
const string _FOLDER = "/folders/";
const string _WORKSPACE_DOC = "/edit";
const int INT_VALUE_8 = 8;
const int INT_VALUE_39 = 39;
const int INT_VALUE_41 = 41;
const int INT_VALUE_42 = 42;
const int INT_VALUE_83 = 83;


//Drive
const string DRIVE_URL = "https://www.googleapis.com";
const string DRIVE_PATH = "/drive/v3";
const string ABOUT = "/about";
const string UPLOAD = "/upload";
const string UPLOAD_TYPE = "uploadType";
const string TYPE_MEDIA = "media";
const string TYPE_MULTIPART = "multipart";
const string TYPE_RESUMABLE = "resumable";
const string FILES = "/files";
const string COPY = "/copy";
const string Q = "q";
const string MIME_TYPE = "mimeType";
const string APPLICATION = "'application/vnd.google-apps.spreadsheet'";
const string AMPERSAND = "&";
const string PAGE_TOKEN = "pageToken";

// Error
const string ERR_FILE_RESPONSE =  "Error occurred while constructing DriveResponse record.";
const string ERR_JSON_TO_FILE_CONVERT =  "Error occurred while constructing File record.";
const string UNABLE_TO_ENCODE = "Unable to encode value: ";

// Optional Query Parameters
// File - GET
const string ACKKNOWLEDGE_ABUSE = "acknowledgeAbuse";
const string FIELDS = "fields";
const string INCLUDE_PERMISSIONS_FOR_VIEW = "includePermissionsForView";
const string SUPPORTS_ALL_DRIVES = "supportsAllDrives";
// File - COPY
const string IGNORE_DEFAULT_VISIBILITY = "ignoreDefaultVisibility";
const string KEEP_REVISION_FOREVER = "keepRevisionForever";
const string OCR_LANGUAGE = "ocrLanguage";
// File - UPDATE
const string ADD_PARENTS = "addParents";
const string REMOVE_PARENTS = "removeParents";
const string USE_CONTENT_AS_INDEXABLE_TEXT = "useContentAsIndexableText";
// File - LIST
const string CORPORA = "corpora";
const string DRIVE_ID = "driveId";
const string ORDER_BY = "orderBy";
const string PAGE_SIZE = "pageSize";
const string SPACES = "spaces";
const string INCLUDE_ITEMS_FROM_ALL_DRIVES = "includeItemsFromAllDrives";

//Headers
const string CONTENT_TYPE = "Content-Type";
const string CONTENT_LENGTH = "Content-Length";
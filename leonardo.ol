
from console import Console
from file import File
from string_utils import StringUtils
from protocols.http import DefaultOperationHttpRequest

interface HTTPInterface {
    RequestResponse:
        get(DefaultOperationHttpRequest)(undefined)
}

type Params {
    location: string
    documentDir: string
}

service Leonardo(p: Params) {

    embed Console as Console
    embed File as File
    embed StringUtils as StringUtils

    execution { concurrent }

    inputPort HTTPInput {
        protocol: http {
            .keepAlive = false;
            .debug = false;
            .debug.showContent = false;
            .format -> format;
            .contentType -> mime;

            .default = "get"
        }
        location: p.location
        interfaces: HTTPInterface
    }

    main {
        [get(request)(response) {
            scope(scope_get) {
                install(FileNotFound => println@Console("File not found: " + file.filename)());

                s = request.operation
                s.regex = "\\?";
                split@StringUtils( s )( s );
                file.filename = p.documentDir + s.result[0];
                file.format = "text"
                format = "html"

                readFile@File(file)(response)
            }
        } ] { nullProcess }
    }
} 

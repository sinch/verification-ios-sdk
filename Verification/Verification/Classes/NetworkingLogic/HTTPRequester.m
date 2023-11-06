//
//  HTTPRequester.m
//
//  Created by BENJAMIN BRYANT BUDIMAN on 05/09/18.
//  Copyright © 2021 Boku, Inc. All rights reserved.
//

#import "HTTPRequester.h"
#import "SocketAddress.h"
#import "sslfuncs.h"
#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <net/if.h>
#import <netdb.h>
#include <arpa/inet.h>

@implementation HTTPRequester

static const NSString *ERROR_RESULT = @"ERROR";
static const NSString *REDIRECT_RESULT = @"REDIRECT:";

static const NSString *PATTERN_REQUEST_BASE = @"GET %@%@ HTTP/1.1\r\nHost: %@%@\r\n";
static const NSString *REQUEST_CONNECTION_CLOSE = @"Connection: close\r\n\r\n";

static const NSString *REGEXP_LOCATION_HEADER = @"Location: (.*)\r\n";

static const NSString *SCHEME_HTTP = @"http";
static const NSString *HTTP_RESPONSE_START = @"HTTP/";

/**
 Requests a URL using the local system's cellular data.
 There are five important steps in this function:
    1). Find the address of the network interface for the local system's cellular data
    2). Find the address of the URL requested
    3). Bind and connect a socket to the addresses obtained from steps 1) and 2)
    4). Invoke the HTTP request using the instantiated socket from step 3)
    5). Parse the HTTP response and check whether it contains a redirect HTTP code. If the HTTP response contains a HTTP redirect code, obtain the redirect URL (which is found from the Location header), and return a string containing the redirect URL. E.g. "REDIRECT:https://redirect-url.com"
 These steps are labeled in the code below.
 
 @param url The URL to be requested
 @return A string response from the request to the URL
 */
+ (NSString *)performGetRequest:(NSURL *)url {
    // Stores any errors that occur during execution
    OSStatus status;
    
    // All local (cellular interface) IP addresses of this device.
    NSMutableArray<SocketAddress *> *localAddresses = [NSMutableArray array];
    // All remote IP addresses that we're trying to connect to.
    NSMutableArray<SocketAddress *> *remoteAddresses = [NSMutableArray array];
    
    // The local (cellular interface) IP address of this device.
    SocketAddress *localAddress;
    // The remote IP address that we're trying to connect to.
    SocketAddress *remoteAddress;
    
    NSPredicate *ipv4Predicate = [NSPredicate predicateWithBlock:^BOOL(SocketAddress *evaluatedObject, NSDictionary<NSString *, id> *bindings) {
        return evaluatedObject.sockaddr->sa_family == AF_INET;
    }];
    NSPredicate *ipv6Predicate = [NSPredicate predicateWithBlock:^BOOL(SocketAddress *evaluatedObject, NSDictionary<NSString *, id> *bindings) {
        return evaluatedObject.sockaddr->sa_family == AF_INET6;
    }];
    
    struct ifaddrs *ifaddrPointer;
    struct ifaddrs *ifaddrs;
    
    // The getifaddrs() function creates a linked list of structures describing the network interfaces of the local system,
    // and stores the address of the first item of the list in *ifaddrPointer.
    // A zero return value for getaddrinfo() indicates successful completion; a non-zero return value indicates failure.
    // For more information, go to https://man7.org/linux/man-pages/man3/getifaddrs.3.html
    status = getifaddrs(&ifaddrPointer);
    if (status) {
        return ERROR_RESULT;
    }
    
    // Step 1). Find the address of the network interface for the local system's cellular data
    
    ifaddrs = ifaddrPointer;
    while (ifaddrs) {
        // If the interface is up
        if (ifaddrs->ifa_flags & IFF_UP) {
            // If the interface is the pdp_ip0 (cellular data) interface
            if (strcmp(ifaddrs->ifa_name, "pdp_ip0") == 0) {
                switch (ifaddrs->ifa_addr->sa_family) {
                    case AF_INET:  // IPv4
                    case AF_INET6: // IPv6
                        [localAddresses addObject:[[SocketAddress alloc] initWithSockaddr:ifaddrs->ifa_addr]];
                        break;
                }
            }
        }
        ifaddrs = ifaddrs->ifa_next;
    }
    
    struct addrinfo *addrinfoPointer;
    struct addrinfo *addrinfo;
    
    // Generate "hints" for the DNS lookup (namely, search for both IPv4 and IPv6 addresses)
    struct addrinfo hints;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_ALL;
  
    char* service = [[url scheme] UTF8String];
    
    if(url.port) {
        NSString *portString = [NSString stringWithFormat: @"%@", [url port]];
        service = [portString UTF8String];
    }
    
    // Step 2). Find the address of the URL requested
    
    // The getaddrinfo() function shall translate the name of a service location (for example, a host name) and/or a service name, and it shall return a set of socket addresses and associated information to be used in creating a socket with which to address the specified service.
    // A zero return value for getaddrinfo() indicates successful completion; a non-zero return value indicates failure.
    // For more information, go to https://pubs.opengroup.org/onlinepubs/009696699/functions/getaddrinfo.html
    status = getaddrinfo([[url host] UTF8String], service, &hints, &addrinfoPointer);
    if (status) {
        freeifaddrs(ifaddrPointer);
        return ERROR_RESULT;
    }
    
    addrinfo = addrinfoPointer;
    
    while (addrinfo) {
        switch (addrinfo->ai_addr->sa_family) {
            case AF_INET: // IPv4
            case AF_INET6: // IPv6
                [remoteAddresses addObject:[[SocketAddress alloc] initWithSockaddr:addrinfo->ai_addr]];
                break;
        }
        addrinfo = addrinfo->ai_next;
    }
    
    // Define the local address (which is the cellular data IP address) and define the remote address (which is the URL we're trying to reach)
    if ((localAddress = [[localAddresses filteredArrayUsingPredicate:ipv6Predicate] lastObject]) && (remoteAddress = [[remoteAddresses filteredArrayUsingPredicate:ipv6Predicate] lastObject])) {
        // Select the IPv6 route, if possible
    } else if ((localAddress = [[localAddresses filteredArrayUsingPredicate:ipv4Predicate] lastObject]) && (remoteAddress = [[remoteAddresses filteredArrayUsingPredicate:ipv4Predicate] lastObject])) {
        // Select the IPv4 route, if possible (and no IPv6 route is available)
    } else {
        // No route found, abort
        freeaddrinfo(addrinfoPointer);
        return ERROR_RESULT;
    }
    
    // Step 3). Bind and connect socket to the addresses obtained from steps 1) and 2).
    
    // Instantiate a new socket
    int sock = socket(localAddress.sockaddr->sa_family, SOCK_STREAM, 0);
    if(sock == -1) {
        return ERROR_RESULT;
    }
    
    // Bind the socket to the local address
    bind(sock, localAddress.sockaddr, localAddress.size);
    
    // Connect to the remote address using the socket
    status = connect(sock, remoteAddress.sockaddr, remoteAddress.size);
    if (status) {
        freeaddrinfo(addrinfoPointer);
        return ERROR_RESULT;
    }
    
    // Create the HTTP request string
    NSString *requestString = [NSString stringWithFormat: PATTERN_REQUEST_BASE, [url path], [url query] ? [@"?" stringByAppendingString:[url query]] : @"", [url host], [url port] ? [@":" stringByAppendingFormat:@"%@", [url port]] : @""];
    
    requestString = [requestString stringByAppendingString: REQUEST_CONNECTION_CLOSE];
    
    const char* request = [requestString UTF8String];

    char buffer[4096];
    
    // Step 4). Invoke the HTTP request using the instantiated socket
    
    if ([[url scheme] isEqualToString: SCHEME_HTTP]) {
        write(sock, request, strlen(request));
        
        int received = 0;
        int total = sizeof(buffer)-1;
        do {
            int bytes = (int)read(sock, buffer+received, total-received);
            if (bytes < 0) {
                return ERROR_RESULT;
            } else if(bytes==0) {
                break;
            }
            
            received += bytes;
        } while (received < total);
    } else { // Setup SSL if the URL is HTTPS
        // SSLCreateContext allocates and returns a new context.
        SSLContextRef context = SSLCreateContext(kCFAllocatorDefault, kSSLClientSide, kSSLStreamType);
        
        // SSLSetIOFuncs specifies functions that perform the network I/O operations. We must call this function prior to calling the SSLHandshake function.
        status = SSLSetIOFuncs(context, ssl_read, ssl_write);
        if (status) {
            SSLClose(context);
            CFRelease(context);
            return ERROR_RESULT;
        }
        
        // SSLSetConnection specifies an I/O connection for a specific session. We must establish a connection before creating a secure session.
        status = SSLSetConnection(context, (SSLConnectionRef)&sock);
        if (status) {
            SSLClose(context);
            CFRelease(context);
            return ERROR_RESULT;
        }
        
        // SSLSetPeerDomainName verifies the common name field in the peer’s certificate. If we call this function and the common name in the certificate does not match the value you specify in the peerName parameter (2nd parameter), then handshake fails and returns an error
        status = SSLSetPeerDomainName(context, [[url host] UTF8String], strlen([[url host] UTF8String]));
        if (status) {
            SSLClose(context);
            CFRelease(context);
            return ERROR_RESULT;
        }
        
        do {
            // SSLHandshake performs the SSL handshake. On successful return, the session is ready for normal secure communication using the functions SSLRead and SSLWrite.
            status = SSLHandshake(context);
        } while (status == errSSLWouldBlock); // Repeat SSL handshake until it doesn't error out.
        if (status) {
            SSLClose(context);
            CFRelease(context);
            return ERROR_RESULT;
        }
        
        size_t processed = 0;
        // SSLWrite performs a typical application-level write operation.
        status = SSLWrite(context, request, strlen(request), &processed);
        if (status) {
            SSLClose(context);
            CFRelease(context);
            return ERROR_RESULT;
        }
        
        do {
            // SSLRead performs a typical application-level read operation.
            status = SSLRead(context, buffer, sizeof(buffer) - 1, &processed);
            buffer[processed] = 0;
            
            // If the buffer was filled, then continue reading
            if (processed == sizeof(buffer) - 1) {
                status = errSSLWouldBlock;
            }
        } while (status == errSSLWouldBlock);
        
        if (status && status != errSSLClosedGraceful) {
            SSLClose(context);
            CFRelease(context);
            return ERROR_RESULT;
        }
    }
    
    NSString *response = [[NSString alloc] initWithBytes:buffer length:sizeof(buffer) encoding:NSASCIIStringEncoding];
    
    // Step 5). Parse the HTTP response and check whether it contains a redirect HTTP code
    if ([response rangeOfString: HTTP_RESPONSE_START].location == NSNotFound) {
        return ERROR_RESULT;
    }
    
    NSUInteger prefixLocation = [response rangeOfString: HTTP_RESPONSE_START].location + 9;
    
    NSRange toReturnRange = NSMakeRange(prefixLocation, 1);
    
    NSString* urlResponseCode = [response substringWithRange:toReturnRange];
    
    // If the HTTP response contains a HTTP redirect code, obtain the redirect URL (which is found from the Location header), and return a string containing the redirect URL.
    // For example, "REDIRECT:https://redirect_url.com"
    if ([urlResponseCode isEqualToString:@"3"]) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: REGEXP_LOCATION_HEADER options:NSRegularExpressionCaseInsensitive error:NULL];
        
        NSArray *myArray = [regex matchesInString:response options:0 range:NSMakeRange(0, [response length])] ;
        
        NSString* redirectLink = @"";
        
        for (NSTextCheckingResult *match in myArray) {
            NSRange matchRange = [match rangeAtIndex:1];
            redirectLink = [response substringWithRange:matchRange];
        }
        
        response = REDIRECT_RESULT;
        response = [response stringByAppendingString:redirectLink];
    }

    return response;
}

@end

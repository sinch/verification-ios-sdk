//
//  sslfuncs.h
//
//  Created by BENJAMIN BRYANT BUDIMAN on 05/09/18.
//  Copyright © 2021 Boku, Inc. All rights reserved.
//

#ifndef sslfuncs_h
#define sslfuncs_h

#import <CoreFoundation/CoreFoundation.h>
#import <Security/SecureTransport.h>

OSStatus ssl_read(SSLConnectionRef connection, void *data, size_t *data_length);
OSStatus ssl_write(SSLConnectionRef connection, const void *data, size_t *data_length);

#endif /* sslfuncs_h */

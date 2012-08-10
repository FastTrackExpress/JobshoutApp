//
//  ServerState.h
//  IcognoCleverbotProject
//
//  Created by Liam Flynn on 18/05/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum ServerState {
	SERVER_OK, SERVER_CONNECT_ERROR, SERVER_TOO_BUSY, SERVER_BLANK_RESPONSE, SERVER_RESPONSE_ERROR, SERVER_TIMEOUT 
}ServerState;
//
//  popobf.h
//  BlowFishTest
//
//  Created by wurong on 14-1-14.
//  Copyright (c) 2014年 Shanghai YuYou. All rights reserved.
//

#ifndef BlowFishTest_popobf_h
#define BlowFishTest_popobf_h

extern void popo_bf_set_key(unsigned char * inOut,int size);
extern int popo_bf_encrypt(unsigned char * inOut,int in_size);
extern int popo_bf_decrypt(unsigned char * inOut,int in_size);

#endif

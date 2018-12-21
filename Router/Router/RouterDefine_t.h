//
//  RouterDefine_t.h
//  Router
//
//  Created by daye1 on 2018/12/9.
//  Copyright © 2018 daye2. All rights reserved.
//

#define STR(s) #s
#define STRING(s) [NSString stringWithFormat:@"%s", STR(s)]

#define R_EXPORT_METHOD_INTERNAL(module, path) \
+ (NSString *)routePath { \
return [NSString stringWithFormat:@"%@:/%@", module, [path hasPrefix:@"/"]?path:[NSString stringWithFormat:@"/%@",path]]; \
}

#define R_EXPORT_VC(sName, identifier) \
+ (UIViewController*) instanceFromStory { \
return [[UIStoryboard storyboardWithName:STRING(sName) bundle:nil] instantiateViewControllerWithIdentifier:STRING(identifier)]; \
}

#define ROUTER_PATH(path) R_EXPORT_METHOD_INTERNAL(ROUTER_HOST, path)
#define ROUTER_STORYBOARD(sName, identifier) R_EXPORT_VC(sName, identifier)

#define ROUTER_HOST @"Router"
#define ROUTER_API(a) [NSString stringWithFormat:@"%@://%@", ROUTER_HOST, a]

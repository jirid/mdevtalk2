//
//  main.m
//  ObjCRuntime
//
//  Created by Jiri Dutkevic on 14/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSArray+Swizzling.h"

void classes() {
    unsigned int classCount = 0;
    Class *classes = objc_copyClassList(&classCount);
    for (unsigned int i = 0; i < classCount; i++) {
        Class class = classes[i];
        const char *name = class_getName(class);
        NSLog(@"%s", name);
    }
    free(classes);
}

void properties() {
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([NSNumber class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSLog(@"%s", name);
    }
    free(properties);
}

void newClass() {
    //@interface Greeter : NSObject
    Class c = objc_allocateClassPair([NSObject class], "Greeter", 0);
    
    //@property (strong, nonatomic, readonly) NSString *name;
    class_addIvar(c, "_name", sizeof(id), log2(sizeof(id)), @encode(id));
    Ivar nameIvar = class_getInstanceVariable(c, "_name");
    
    IMP nameIMP = imp_implementationWithBlock(^(id self) {
        return object_getIvar(self, nameIvar);
    });
    const char *nameTypes = [[NSString stringWithFormat:@"%s%s%s", @encode(id), @encode(id), @encode(SEL)] UTF8String];
    SEL nameSelector = sel_registerName("name");
    class_addMethod(c, nameSelector, nameIMP, nameTypes);
    
    //- (instancetype)initWithName:(NSString *)name;
    IMP initIMP=imp_implementationWithBlock(^(id self, NSString *name) {
        object_setIvar(self, nameIvar, name);
        return self;
    });
    const char *initTypes = [[NSString stringWithFormat:@"%s%s%s%s", @encode(id), @encode(id), @encode(SEL), @encode(id)] UTF8String];
    SEL initSelector = sel_registerName("initWithName:");
    class_addMethod(c, initSelector, initIMP, initTypes);
    
    //- (void)sayHello;
    IMP sayHelloIMP=imp_implementationWithBlock(^(id self) {
        NSLog(@"Hello %@", [self name]);
    });
    const char *sayHelloTypes = [[NSString stringWithFormat:@"%s%s%s", @encode(id), @encode(id), @encode(SEL)] UTF8String];
    SEL sayHelloSelector = sel_registerName("sayHello");
    class_addMethod(c, sayHelloSelector, sayHelloIMP, sayHelloTypes);
    
    //@end
    objc_registerClassPair(c);
    
    id p = [[c alloc] initWithName:@"mDevTalk #2"];
    [p performSelector:sayHelloSelector];
}

void swizzling() {
    NSArray *array = @[@1, @2, @3, @4, @5];
    
    NSLog(@"Count: %lu", (unsigned long)[array count]);
    for (NSUInteger i = 0; i < [array count]; i++) {
        NSLog(@"%lu: %@", (unsigned long)i, array[i]);
    }
    
    Class cls = objc_getClass("__NSArrayI");
    Method m1 = class_getInstanceMethod(cls, @selector(count));
    Method m2 = class_getInstanceMethod(cls, @selector(myCount));
    method_exchangeImplementations(m1, m2);
    
    NSLog(@"Count: %lu", (unsigned long)[array count]);
    for (NSUInteger i = 0; i < [array count]; i++) {
        NSLog(@"%lu: %@", (unsigned long)i, array[i]);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        classes();
//        properties();
//        newClass();
//        swizzling();
    }
    return 0;
}

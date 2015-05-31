//
//  LLDBObject.h
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#pragma once
#import "BasicObject.h"
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


/*!
 Base class of all LLDB proxy objects.
 */
@interface LLDBObject : BasicObject
- (instancetype)init;

@end

//id		LLDBObject_init(LLDBObject* self);
//BOOL	LLDBObject_isKindOfClass(LLDBObject* self, Class aClass);
//void	LLDBObject_doesNotRecognizeSelector(LLDBObject* self, SEL aSelector);

@interface LLDBObject (LLDBUnavailableMethods)
- (NSString *)accessibilityActionDescription:(NSString *)action UNIVERSE_UNAVAILABLE_METHOD;
- (NSArray *)accessibilityActionNames UNIVERSE_UNAVAILABLE_METHOD;
- (NSUInteger)accessibilityArrayAttributeCount:(NSString *)attribute UNIVERSE_UNAVAILABLE_METHOD;
- (NSArray *)accessibilityArrayAttributeValues:(NSString *)attribute index:(NSUInteger)index maxCount:(NSUInteger)maxCount UNIVERSE_UNAVAILABLE_METHOD;
- (NSArray *)accessibilityAttributeNames UNIVERSE_UNAVAILABLE_METHOD;
- (id)accessibilityAttributeValue:(NSString *)attribute UNIVERSE_UNAVAILABLE_METHOD;
- (id)accessibilityAttributeValue:(NSString *)attribute forParameter:(id)parameter UNIVERSE_UNAVAILABLE_METHOD;
- (id)accessibilityFocusedUIElement UNIVERSE_UNAVAILABLE_METHOD;
- (NSUInteger)accessibilityIndexOfChild:(id)child UNIVERSE_UNAVAILABLE_METHOD;
- (id)accessibilityHitTest:(NSPoint)point UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)accessibilityIsAttributeSettable:(NSString *)attribute UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)accessibilityIsIgnored UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)accessibilityNotifiesWhenDestroyed UNIVERSE_UNAVAILABLE_METHOD;
- (NSArray *)accessibilityParameterizedAttributeNames UNIVERSE_UNAVAILABLE_METHOD;
- (void)accessibilityPerformAction:(NSString *)action UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)accessibilitySetOverrideValue:(id)value forAttribute:(NSString *)attribute UNIVERSE_UNAVAILABLE_METHOD;
- (void)accessibilitySetValue:(id)value forAttribute:(NSString *)attribute UNIVERSE_UNAVAILABLE_METHOD;
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event UNIVERSE_UNAVAILABLE_METHOD;
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)application:(NSApplication *)sender delegateHandlesKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex UNIVERSE_UNAVAILABLE_METHOD;
- (void)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex delegate:(id)delegate didRecoverSelector:(SEL)didRecoverSelector contextInfo:(void *)contextInfo UNIVERSE_UNAVAILABLE_METHOD;
- (NSArray *)attributeKeys UNIVERSE_UNAVAILABLE_METHOD;
- (id)autoContentAccessingProxy UNIVERSE_UNAVAILABLE_METHOD;
- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder UNIVERSE_UNAVAILABLE_METHOD;
- (void)awakeFromNib UNIVERSE_UNAVAILABLE_METHOD;
- (void)animationDidStart:(CAAnimation *)anim UNIVERSE_UNAVAILABLE_METHOD;
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag UNIVERSE_UNAVAILABLE_METHOD;

- (void)bind:(NSString *)binding toObject:(id)observable withKeyPath:(NSString *)keyPath options:(NSDictionary *)options UNIVERSE_UNAVAILABLE_METHOD;

- (void)changeColor:(id)sender UNIVERSE_UNAVAILABLE_METHOD;
- (void)changeFont:(id)sender UNIVERSE_UNAVAILABLE_METHOD;
- (FourCharCode)classCode UNIVERSE_UNAVAILABLE_METHOD;
- (NSClassDescription *)classDescription UNIVERSE_UNAVAILABLE_METHOD;
- (Class)classForArchiver UNIVERSE_UNAVAILABLE_METHOD;
- (Class)classForCoder UNIVERSE_UNAVAILABLE_METHOD;
- (Class)classForKeyedArchiver UNIVERSE_UNAVAILABLE_METHOD;
- (Class)classForPortCoder UNIVERSE_UNAVAILABLE_METHOD;
- (NSString *)className UNIVERSE_UNAVAILABLE_METHOD;
- (id)coerceValue:(id)value forKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)commitEditing UNIVERSE_UNAVAILABLE_METHOD;
- (Class)class UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)commitEditingAndReturnError:(NSError *__autoreleasing *)error UNIVERSE_UNAVAILABLE_METHOD;
- (void)commitEditingWithDelegate:(id)delegate didCommitSelector:(SEL)didCommitSelector contextInfo:(void *)contextInfo UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)conformsToProtocol:(Protocol *)aProtocol UNIVERSE_UNAVAILABLE_METHOD;
- (void)controlTextDidBeginEditing:(NSNotification *)obj UNIVERSE_UNAVAILABLE_METHOD;
- (void)controlTextDidChange:(NSNotification *)obj UNIVERSE_UNAVAILABLE_METHOD;
- (void)controlTextDidEndEditing:(NSNotification *)obj UNIVERSE_UNAVAILABLE_METHOD;

- (void)dealloc UNIVERSE_UNAVAILABLE_METHOD;
- (NSString *)debugDescription UNIVERSE_UNAVAILABLE_METHOD;
- (NSString *)description UNIVERSE_UNAVAILABLE_METHOD;
- (NSDictionary *)dictionaryWithValuesForKeys:(NSArray *)keys UNIVERSE_UNAVAILABLE_METHOD;
- (void)didChange:(NSKeyValueChange)changeKind valuesAtIndexes:(NSIndexSet *)indexes forKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (void)didChangeValueForKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (void)didChangeValueForKey:(NSString *)key withSetMutation:(NSKeyValueSetMutationKind)mutationKind usingObjects:(NSSet *)objects UNIVERSE_UNAVAILABLE_METHOD;
- (void)discardEditing UNIVERSE_UNAVAILABLE_METHOD;
- (void)displayLayer:(CALayer *)layer UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)doesContain:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx UNIVERSE_UNAVAILABLE_METHOD;
- (void)doesNotRecognizeSelector:(SEL)aSelector UNIVERSE_UNAVAILABLE_METHOD;

- (NSArray *)exposedBindings UNIVERSE_UNAVAILABLE_METHOD;

- (void)finalize UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)fontManager:(id)sender willIncludeFont:(NSString *)fontName UNIVERSE_UNAVAILABLE_METHOD;
- (id)forwardingTargetForSelector:(SEL)aSelector UNIVERSE_UNAVAILABLE_METHOD;
- (void)forwardInvocation:(NSInvocation *)anInvocation UNIVERSE_UNAVAILABLE_METHOD;
- (NSUInteger)hash UNIVERSE_UNAVAILABLE_METHOD;

- (NSArray *)indicesOfObjectsByEvaluatingObjectSpecifier:(NSScriptObjectSpecifier *)specifier UNIVERSE_UNAVAILABLE_METHOD;
- (NSDictionary *)infoForBinding:(NSString *)binding UNIVERSE_UNAVAILABLE_METHOD;
- (void)insertValue:(id)value atIndex:(NSUInteger)index inPropertyWithKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (void)insertValue:(id)value inPropertyWithKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (void)invalidateLayoutOfLayer:(CALayer *)layer UNIVERSE_UNAVAILABLE_METHOD;
- (NSString *)inverseForRelationshipKey:(NSString *)relationshipKey UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isCaseInsensitiveLike:(NSString *)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isEqual:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isExplicitlyIncluded UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isGreaterThan:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isGreaterThanOrEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isLessThan:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isLessThanOrEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isLike:(NSString *)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isMemberOfClass:(Class)aClass UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isNotEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isProxy UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isKindOfClass:(Class)aClass UNIVERSE_UNAVAILABLE_METHOD;

- (NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)layer:(CALayer *)layer shouldInheritContentsScale:(CGFloat)newScale fromWindow:(NSWindow *)window UNIVERSE_UNAVAILABLE_METHOD;
- (void)layoutSublayersOfLayer:(CALayer *)layer UNIVERSE_UNAVAILABLE_METHOD;
- (NSString *)localizedKey UNIVERSE_UNAVAILABLE_METHOD;

- (IMP)methodForSelector:(SEL)aSelector UNIVERSE_UNAVAILABLE_METHOD;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector UNIVERSE_UNAVAILABLE_METHOD;
- (NSMutableArray *)mutableArrayValueForKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (NSMutableArray *)mutableArrayValueForKeyPath:(NSString *)keyPath UNIVERSE_UNAVAILABLE_METHOD;
- (NSMutableOrderedSet *)mutableOrderedSetValueForKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (NSMutableOrderedSet *)mutableOrderedSetValueForKeyPath:(NSString *)keyPath UNIVERSE_UNAVAILABLE_METHOD;
- (NSMutableSet *)mutableSetValueForKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (NSMutableSet *)mutableSetValueForKeyPath:(NSString *)keyPath UNIVERSE_UNAVAILABLE_METHOD;

- (NSArray *)namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination UNIVERSE_UNAVAILABLE_METHOD;
- (id)newScriptingObjectOfClass:(Class)objectClass forValueForKey:(NSString *)key withContentsValue:(id)contentsValue properties:(NSDictionary *)properties UNIVERSE_UNAVAILABLE_METHOD;

- (void)objectDidBeginEditing:(id)editor UNIVERSE_UNAVAILABLE_METHOD;
- (void)objectDidEndEditing:(id)editor UNIVERSE_UNAVAILABLE_METHOD;
- (NSScriptObjectSpecifier *)objectSpecifier UNIVERSE_UNAVAILABLE_METHOD;
- (void *)observationInfo UNIVERSE_UNAVAILABLE_METHOD;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context UNIVERSE_UNAVAILABLE_METHOD;
- (NSArray *)optionDescriptionsForBinding:(NSString *)aBinding UNIVERSE_UNAVAILABLE_METHOD;

- (void)pasteboard:(NSPasteboard *)sender provideDataForType:(NSString *)type UNIVERSE_UNAVAILABLE_METHOD;
- (void)pasteboardChangedOwner:(NSPasteboard *)sender UNIVERSE_UNAVAILABLE_METHOD;
- (id)performSelector:(SEL)aSelector UNIVERSE_UNAVAILABLE_METHOD;
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait UNIVERSE_UNAVAILABLE_METHOD;
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array UNIVERSE_UNAVAILABLE_METHOD;
- (id)performSelector:(SEL)aSelector withObject:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay UNIVERSE_UNAVAILABLE_METHOD;
- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay inModes:(NSArray *)modes UNIVERSE_UNAVAILABLE_METHOD;
- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 UNIVERSE_UNAVAILABLE_METHOD;
- (void)performSelectorInBackground:(SEL)aSelector withObject:(id)arg UNIVERSE_UNAVAILABLE_METHOD;
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait UNIVERSE_UNAVAILABLE_METHOD;
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait modes:(NSArray *)array UNIVERSE_UNAVAILABLE_METHOD;
- (CGSize)preferredSizeOfLayer:(CALayer *)layer UNIVERSE_UNAVAILABLE_METHOD;
- (void)prepareForInterfaceBuilder UNIVERSE_UNAVAILABLE_METHOD;
- (void)provideImageData:(void *)data bytesPerRow:(size_t)rowbytes origin:(size_t)x :(size_t)y size:(size_t)width :(size_t)height userInfo:(id)info UNIVERSE_UNAVAILABLE_METHOD;

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath UNIVERSE_UNAVAILABLE_METHOD;
- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context UNIVERSE_UNAVAILABLE_METHOD;
- (void)removeValueAtIndex:(NSUInteger)index fromPropertyWithKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (id)replacementObjectForArchiver:(NSArchiver *)archiver UNIVERSE_UNAVAILABLE_METHOD;
- (id)replacementObjectForCoder:(NSCoder *)aCoder UNIVERSE_UNAVAILABLE_METHOD;
- (id)replacementObjectForKeyedArchiver:(NSKeyedArchiver *)archiver UNIVERSE_UNAVAILABLE_METHOD;
- (id)replacementObjectForPortCoder:(NSPortCoder *)coder UNIVERSE_UNAVAILABLE_METHOD;
- (void)replaceValueAtIndex:(NSUInteger)index inPropertyWithKey:(NSString *)key withValue:(id)value UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)respondsToSelector:(SEL)aSelector UNIVERSE_UNAVAILABLE_METHOD;

- (BOOL)scriptingBeginsWith:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)scriptingContains:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)scriptingEndsWith:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)scriptingIsEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)scriptingIsGreaterThan:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)scriptingIsGreaterThanOrEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)scriptingIsLessThan:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)scriptingIsLessThanOrEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (NSDictionary *)scriptingProperties UNIVERSE_UNAVAILABLE_METHOD;
- (id)scriptingValueForSpecifier:(NSScriptObjectSpecifier *)objectSpecifier UNIVERSE_UNAVAILABLE_METHOD;
- (instancetype)self UNIVERSE_UNAVAILABLE_METHOD;
- (void)setKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (void)setLocalizedKey:(NSString *)localizedKey UNIVERSE_UNAVAILABLE_METHOD;
- (void)setNilValueForKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (void)setObservationInfo:(void *)observationInfo UNIVERSE_UNAVAILABLE_METHOD;
- (void)setScriptingProperties:(NSDictionary *)scriptingProperties UNIVERSE_UNAVAILABLE_METHOD;
- (void)setValue:(id)value UNIVERSE_UNAVAILABLE_METHOD;
- (void)setValue:(id)value forKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath UNIVERSE_UNAVAILABLE_METHOD;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues UNIVERSE_UNAVAILABLE_METHOD;
- (Class)superclass UNIVERSE_UNAVAILABLE_METHOD;

- (NSArray *)toManyRelationshipKeys UNIVERSE_UNAVAILABLE_METHOD;
- (NSArray *)toOneRelationshipKeys UNIVERSE_UNAVAILABLE_METHOD;

- (void)unbind:(NSString *)binding UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)validateValue:(inout __autoreleasing id *)ioValue forKey:(NSString *)inKey error:(out NSError *__autoreleasing *)outError UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)validateValue:(inout __autoreleasing id *)ioValue forKeyPath:(NSString *)inKeyPath error:(out NSError *__autoreleasing *)outError UNIVERSE_UNAVAILABLE_METHOD;
- (NSUInteger)validModesForFontPanel:(NSFontPanel *)fontPanel UNIVERSE_UNAVAILABLE_METHOD;
- (id)value UNIVERSE_UNAVAILABLE_METHOD;
- (id)valueAtIndex:(NSUInteger)index inPropertyWithKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (Class)valueClassForBinding:(NSString *)binding UNIVERSE_UNAVAILABLE_METHOD;
- (id)valueForKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (id)valueForKeyPath:(NSString *)keyPath UNIVERSE_UNAVAILABLE_METHOD;
- (id)valueForUndefinedKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (id)valueWithName:(NSString *)name inPropertyWithKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (id)valueWithUniqueID:(id)uniqueID inPropertyWithKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (NSString *)view:(NSView *)view stringForToolTip:(NSToolTipTag)tag point:(NSPoint)point userData:(void *)data UNIVERSE_UNAVAILABLE_METHOD;
- (void)willChange:(NSKeyValueChange)changeKind valuesAtIndexes:(NSIndexSet *)indexes forKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (void)willChangeValueForKey:(NSString *)key UNIVERSE_UNAVAILABLE_METHOD;
- (void)willChangeValueForKey:(NSString *)key withSetMutation:(NSKeyValueSetMutationKind)mutationKind usingObjects:(NSSet *)objects UNIVERSE_UNAVAILABLE_METHOD;
- (struct _NSZone *)zone UNIVERSE_UNAVAILABLE_METHOD;

@end












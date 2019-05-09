//
//  VideoFramePool.h
//  ismartsee-A 
//
//

#import <Foundation/Foundation.h>
#define IOS10 ([UIDevice currentDevice].systemVersion.floatValue >= 10.0)
@protocol VSNetFrameProtocol <NSObject>
/**
 *  帧数据
 */
- (void) VSNetFrameData: (NSData*) frameData width:(int) width height:(int) height;
@end

@interface VideoFramePool : NSObject{
    dispatch_queue_t queue;
    CADisplayLink *displayLink;
    NSMutableArray* frameArray;
    NSCondition *m_DataLock;
    struct timeval time;
    int rate;
    int frameRate;
}

-(instancetype)init;

/**
 开始缓存线程
按照传入的帧率进行缓存,并通过delegate进行帧数据回调
 @param rate 帧率
 */
-(void)startWithFrameRate:(int)rate;

/**
 停止缓存线程
 停止后无法再次调用startWithFrameRate:方法开始.
 需要重新init
 */
-(void)clear;
-(void)stop;

/**
 将接收到的帧数据推进缓存池

 @param frameData 帧数据
 @param width 宽
 @param height 高
 */
-(void)pushVideoData:(NSData*) frameData videoWidth:(int) width videoHeight:(int) height;

/**
 委托
 返回缓存池中缓存的数据
 */
@property(atomic,retain) id<VSNetFrameProtocol> delegate;

@end

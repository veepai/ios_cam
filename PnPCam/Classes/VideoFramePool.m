//
//  VideoFramePool.m

#import "VideoFramePool.h"
#import <sys/time.h>

@implementation VideoFramePool

-(instancetype)init{
    self = [super init];
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    frameArray = [[NSMutableArray alloc] initWithCapacity:50];
    [frameArray removeAllObjects];
    m_DataLock = [[NSCondition alloc] init];
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(playVideo)];
    return self;
}

-(void)startWithFrameRate:(int)rate{
    if (queue == nil) {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    }
    if (frameArray == nil) {
         frameArray = [[NSMutableArray alloc] initWithCapacity:50];
    }
    if (m_DataLock == nil) {
        m_DataLock = [[NSCondition alloc] init];
    }
    if (displayLink == nil) {
         displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(playVideo)];
    }
    frameRate = rate;
    NSLog(@"调用次数---displayLink-线程:%@",[NSThread currentThread]);
    if (IOS10) {
        displayLink.preferredFramesPerSecond = frameRate;
    }
    else{
        displayLink.frameInterval = 60 / frameRate;
    }
    dispatch_sync(queue, ^{
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    });
    if (displayLink.paused) {
        displayLink.paused = NO;
    }
}
-(void)clear{
    if (m_DataLock) {
        [m_DataLock lock];
    }
    [frameArray removeAllObjects];
    if (!displayLink.paused) {
        displayLink.paused = YES;
    }
    if (m_DataLock) {
        [m_DataLock unlock];
    }
}
-(void)stop{
    if (displayLink) {
        if (!displayLink.paused) {
            displayLink.paused = YES;
        }
        [displayLink invalidate];
        displayLink = nil;
    }
    if (m_DataLock) {
        [m_DataLock lock];
    }
    if (frameArray) {
        [frameArray removeAllObjects];
        frameArray = nil;
    }
    if (m_DataLock) {
        [m_DataLock unlock];
        m_DataLock = nil;
    }
    if (queue) {
        queue = nil;
    }
}

-(void)pushVideoData:(NSData*) frameData videoWidth:(int) width videoHeight:(int) height{
    [m_DataLock lock];
    while (frameArray.count > frameRate) {
        [frameArray removeObjectAtIndex:0];
    }
    [frameArray addObject:@{@"frame":frameData,@"width":[NSNumber numberWithInt:width],@"height":[NSNumber numberWithInt:height]}];
    [m_DataLock unlock];
}

-(void)playVideo{
    struct timeval nowtime;
    gettimeofday(&nowtime, NULL);
    if (time.tv_sec == 0) {
        memcpy(&time, &nowtime, sizeof(struct timeval));
    }
    if (nowtime.tv_sec != time.tv_sec)
    {
        memcpy(&time, &nowtime, sizeof(struct timeval));
        //NSLog(@"frame size pool:%ld rate:%d",(long)frameArray.count,rate);
        rate = 0;
    }
    
    [m_DataLock lock];
    if (frameArray.count <= 5) {
        if (IOS10) {
            displayLink.preferredFramesPerSecond = 10;
        }
        else{
            displayLink.frameInterval = 60 / 10;
        }
    }
    else{
        if (IOS10) {
            displayLink.preferredFramesPerSecond = frameRate;
        }
        else{
            displayLink.frameInterval = 60 / frameRate;
        }
    }
    NSDictionary *frameData = [frameArray firstObject];
    if (frameData) {
        [frameArray removeObjectAtIndex:0];
    }
    [m_DataLock unlock];
    
    if (frameData) {
        rate ++;
        if (self.delegate) {
              //NSLog(@"缓存 size pool:%ld rate:%d",(long)frameArray.count,rate);
            [self.delegate VSNetFrameData:frameData[@"frame"] width:[frameData[@"width"] intValue] height:[frameData[@"height"] intValue]];
        }
    }
}

@end

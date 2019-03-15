#import "ASTSetupPageView.h"

@interface ASTSetupPageView ()

@end

@implementation ASTSetupPageView{
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setBackgroundColor: [UIColor whiteColor]];
        [self setUserInteractionEnabled:TRUE];
        
        //Big Title at the top
        self.bigTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, 100)];
        self.bigTitle.textAlignment = NSTextAlignmentCenter;
        self.bigTitle.font = [UIFont boldSystemFontOfSize:35];
        [self addSubview:self.bigTitle];
        
        //Description below Big Title
        self.titleDescription = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.1, 75, self.frame.size.width*0.8, 100)];
        self.titleDescription.textAlignment = NSTextAlignmentCenter;
        self.titleDescription.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleDescription.numberOfLines = 0;
        self.titleDescription.font = [UIFont systemFontOfSize:20];
        [self addSubview: self.titleDescription];
        
        // Next button
        self.nextButton = [[HighlightButton alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nextButton.backgroundColor = [UIColor colorWithRed:10 / 255.0 green:106 / 255.0 blue:255 / 255.0 alpha:1.0];
        self.nextButton.layer.cornerRadius = 7.5;
        self.nextButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.nextButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height/1.09);
        self.nextButton.titleLabel.textColor = [UIColor whiteColor];
        self.nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.nextButton];
        
    }
    return self;
}

-(void) setupVideoWithPathToFile:(NSString *) pathToFile{
    //Center Video
    CGFloat width = (self.frame.size.height*0.59)/1.777777777;
    CGFloat height = self.frame.size.height*0.59;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathToFile]){
        NSString *moviePath = pathToFile;
        self.videoPlayer = [AVPlayer playerWithURL:[NSURL fileURLWithPath:moviePath]];
        self.playerLayer = [AVPlayerLayer layer];
        self.playerLayer.player = self.videoPlayer;
        self.playerLayer.frame = CGRectMake(self.frame.size.width/2-((self.frame.size.height*0.59)/1.777777777)/2, 150, width, height);
        self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        self.playerLayer.videoGravity = AVLayerVideoGravityResize;
        self.videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.videoPlayer currentItem]];
        [self.layer addSublayer:self.playerLayer];
    }
}

-(void) setNextButtonTarget: (id) object withAction:(SEL) selector{
    [self.nextButton addTarget:object action:selector forControlEvents:UIControlEventTouchUpInside];
}
@end
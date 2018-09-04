#include <lockweather.h>
//kiet was here
/*
// getting values
UIColor *myColor = [prefs colorForKey:@"kMyColorKey"];
NSString *mystring = [prefs stringForKey:@"kMyColorKey"];
BOOL myBOOL = [prefs boolForKey:@"kMyColorKey"];
int myInt = [prefs intForKey:@"kMyColorKey"];
float myFloat = [prefs floatForKey:@"kMyColorKey"];
double myDouble = [prefs doubleForKey:@"kMyColorKey"];

// setting values
id myValue = @"My Custom Value";
[prefs setObject:myValue forKey:@"kMyCustomValue"];

// removing values
[prefs removeObjectForKey: @"kMyCustomValue"];

// saving prefs
[prefs save];

// save and send notification that prefs have been changed
[prefs saveAndPostNotification];
*/
static NSString *condition;



@interface SBDashBoardViewController : UIViewController
@property (retain, nonatomic) UIView *weatherView;
@property (retain, nonatomic) UILabel *currentLabel;
@property (retain, nonatomic) UILabel *tempLabel;
@property (retain, nonatomic) UILabel *greetLabel;
@property (retain, nonatomic) UIVisualEffectView *blurView;
@property (retain, nonatomic) UIView *iconView;
@end

@interface UIBlurEffect (lockweather)
+(id)effectWithBlurRadius:(double)arg1 ;
@end

%hook SBDashBoardViewController   // whats this? idk something kiet put here
%property (retain, nonatomic) UIView *weatherView;
%property (retain, nonatomic) UIView *iconView;
%property (retain, nonatomic) UILabel *currentLabel;
%property (retain, nonatomic) UILabel *greetLabel;
%property (retain, nonatomic) UILabel *tempLabel;
%property (retain, nonatomic) UIVisualEffectView *blurView;

-(void)viewDidLoad {

  // Creating the weatherView which will hold all the other stuff we add (centralization)
  if(!self.weatherView){
    self.weatherView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    [self.weatherView setBackgroundColor: [UIColor clearColor]]; //just realised we dont need to color this
    [self.weatherView setUserInteractionEnabled:FALSE ];
  }
  // Creating the blurView
  /*if(!self.blurView){
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithBlurRadius:20];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurView.frame = self.weatherView.frame;
    self.blurView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    [self.view addSubview: self.blurView];
    [self.view sendSubviewToBack: self.blurView];
  }*/

  // Creating the label to hold the information


  // adding the weatherView to the SBUIBackgroundView
  [self.view addSubview:self.weatherView];

}
-(void) viewWillLayoutSubviews{
  %orig;
  if(!self.currentLabel){

    [[CSWeatherInformationProvider sharedProvider] updatedWeatherWithCompletion:^(NSDictionary *weather) {
      NSString *description = weather[@"kCurrentDescription"];
      NSString *temp = weather[@"kCurrentTemperatureForLocale"];
      NSLog(@"CURRENTTEMP %@", temp);

      self.currentLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/20), (self.view.frame.size.height/3), 300, 20)]; //Ignore the arbitrary 20, I was just messing around with it
      [self.currentLabel setTextColor:[UIColor whiteColor]];

      self.currentLabel.text = description;
      self.currentLabel.numberOfLines = 0;
      [self.currentLabel setBackgroundColor:[UIColor clearColor]];
      [self.currentLabel setFont:[UIFont fontWithName: @"HelveticaNeue" size: 20.0f]]; //understandable :)
      [self.currentLabel sizeToFit];
      [self.weatherView addSubview:self.currentLabel];
      [self.currentLabel setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 1.75)];
      self.currentLabel.textAlignment = NSTextAlignmentCenter;
      [self.weatherView bringSubviewToFront:self.currentLabel];


      self.tempLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/50), (self.view.frame.size.height/3), 300, 20)]; //Ignore the arbitrary 20, I was just messing around with it
      [self.tempLabel setTextColor:[UIColor whiteColor]];

      self.tempLabel.text = temp;
      self.tempLabel.numberOfLines = 0;
      [self.tempLabel setBackgroundColor:[UIColor clearColor]];
      [self.tempLabel setFont:[UIFont fontWithName: @"HelveticaNeue" size: 40.0f]]; //understandable :)
      [self.tempLabel sizeToFit];
      [self.view addSubview:self.tempLabel];
      [self.tempLabel setCenter:CGPointMake(self.view.frame.size.width / 1.8, self.view.frame.size.height / 1.5)];
      [self.weatherView bringSubviewToFront:self.tempLabel];

      self.greetLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/10), (self.view.frame.size.height/25), 300, 20)]; //Ignore the arbitrary 20, I was just messing around with it
      [self.greetLabel setTextColor:[UIColor whiteColor]];
      NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
      [dateFormat setDateFormat:@"HH"];
      NSString *stringFromDate = [dateFormat stringFromDate:[NSDate date]];
      NSInteger integerDate = [stringFromDate integerValue];
      if(integerDate < 4){
        self.greetLabel.text = @"Good Evening";
      }else if (integerDate >= 4 && integerDate < 12){
        self.greetLabel.text = @"Good Morning";
      }else if (integerDate >= 12 && integerDate < 16){
        self.greetLabel.text = @"Good AfterNoon";
      }else if (integerDate >= 15 && integerDate <=24){
        self.greetLabel.text = @"Good Evening";
      }

      self.greetLabel.numberOfLines = 0;
      [self.greetLabel setBackgroundColor:[UIColor clearColor]];
      [self.greetLabel setFont:[UIFont fontWithName: @"HelveticaNeue" size: 40.0f]]; //understandable :)
      [self.greetLabel sizeToFit];
      [self.view addSubview:self.greetLabel];
      self.greetLabel.textAlignment = NSTextAlignmentCenter;
      [self.greetLabel setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
      [self.weatherView bringSubviewToFront:self.greetLabel];
    }];
    //NSString *__block condition;


  }

  if(!self.iconView){
    [[CSWeatherInformationProvider sharedProvider] updatedWeatherWithCompletion:^(NSDictionary *weather) {
      UIImage *image = weather[@"kCurrentConditionImage_nc-variant"];
      NSLog(@"IMAGE %@", [image description]);
      //UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, 100, 100)];
      imageView.image = image;
      imageView.contentMode = UIViewContentModeScaleAspectFit;
      [imageView setCenter:CGPointMake(self.view.frame.size.width / 2.5, self.view.frame.size.height / 1.5)];
      //imageView.frame = iconView.bounds;

      [self.view addSubview:imageView];
      //[self.weatherView bringSubviewToFront:imageView];
    }];
  }

    //self.testLabel.text = string;
}
%end

//
//  ViewController.m
//  STPop
//
//  Created by 岳克奎 on 17/3/6.
//  Copyright © 2017年 STYue. All rights reserved.
//

#import "ViewController.h"
  #import <pop/POP.h>
@interface ViewController ()<POPAnimationDelegate>
@property(nonatomic) UIControl *dragView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

// https://yq.aliyun.com/articles/29585

//Spring
- (IBAction)SpringEffect:(UIButton *)sender {
    // new layer
    CALayer *layer        = [CALayer layer];
    layer.frame           = CGRectMake(0, 0, 50, 50);
    layer.backgroundColor = [UIColor cyanColor].CGColor;
    layer.cornerRadius    = 25.f;
    layer.position        = self.view.center;
    [self.view.layer addSublayer:layer];
    
    // loading Spring animation  ScaleXY
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.toValue             = [NSValue valueWithCGPoint:CGPointMake(3.f, 3.f)];
    anim.springSpeed         = 0.f;
    [layer pop_addAnimation:anim forKey:@"ScaleXY"];
}
//Attenuation
- (IBAction)AttenuationEffect:(UIButton *)sender {
    // 初始化dragView
    self.dragView                    = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.dragView.center             = self.view.center;
    self.dragView.layer.cornerRadius = CGRectGetWidth(self.dragView.bounds)/2;
    self.dragView.backgroundColor    = [UIColor cyanColor];
    [self.view addSubview:self.dragView];
    [self.dragView addTarget:self
                      action:@selector(touchDown:)
            forControlEvents:UIControlEventTouchDown];
    
    
    // 添加手势
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    [self.dragView addGestureRecognizer:recognizer];
    
}
- (void)touchDown:(UIControl *)sender {
    [sender.layer pop_removeAllAnimations];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    // 拖拽
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    // 拖拽动作结束
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        // 计算出移动的速度
        CGPoint velocity = [recognizer velocityInView:self.view];
        
        // 衰退减速动画
        POPDecayAnimation *positionAnimation = \
        [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        
        // 设置代理
        positionAnimation.delegate = self;
        
        // 设置速度动画
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        
        // 添加动画
        [recognizer.view.layer pop_addAnimation:positionAnimation
                                         forKey:@"layerPositionAnimation"];
    }
}
//BaseAniamtion
//eg set view  changing alpha Effect
- (IBAction)AlphaView:(UIButton *)sender {
    // 创建view
    UIView *showView            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    showView.alpha              = 0.f;
    showView.layer.cornerRadius = 50.f;
    showView.center             = self.view.center;
    showView.backgroundColor    = [UIColor cyanColor];
    [self.view addSubview:showView];
    
    // 执行基本动画效果
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction     = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue          = @(0.0);
    anim.toValue            = @(1.0);
    anim.duration           = 4.f;
    [showView pop_addAnimation:anim forKey:@"fade"];
}


@end

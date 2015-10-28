//
//  ViewController.m
//  ScrollDemo
//
//  Created by Jason Li on 2/7/15.
//  Copyright (c) 2015年 李涛. All rights reserved.
//



#define TableViewTop 183
#define TableViewBottom 350
#import "ViewController.h"
#import "CircleView.h"

@interface ViewController ()
{
    //创建头视图一个UIimageView
    UIImageView *_headImageView;
    //分页控件
    UIPageControl *_pageControl;
    //创建手环圆圈的视图
    CircleView *_bandCircleView;
    //创建运动圆圈的视图
    CircleView *_runCircleView;
    //创建体重圆圈的视图
    CircleView *_weightCircleView;
    //创建tableView
    UITableView *_tableView;
    //上次滑动的位置，区间是0和最大偏移量
    CGFloat _lastContentOffset;
    //下拉刷新的图标
    UIImageView *_downRefreshImageView;
    //下拉刷新的提示label
    UILabel *_downRefreshLabel;
    //头视图上的title
    UILabel *_titleLabel;
    //手环圆圈
    UILabel *_sleepStateLabel;
    UILabel *_timeLabel;
    UILabel *_deepSleepLabel;
    //运动圆圈
    UILabel *_stepLabel;
    UILabel *_stepStateLabel;
    UILabel *_stepNumLabel;
    UILabel *_stepDistanceLabel;
    //重量圆圈
    UILabel *_kgLabel;
    UILabel *_weightNumLabel;
    UILabel *_weightStateLabel;
    
    //导航右键的动画相关
    NSArray *_nameArray;
    NSMutableArray *_buttonViewArray;
    UIView *_listView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lastContentOffset=0;
    _nameArray=@[@"分享",@"亲友",@"服务",@"跑步",@"个人信息",@"智能闹钟",@"我的设备",@"取消"];
    [self initView];
    // Do any additional setup after loading the view, typically from a nib.
}
//创建视图
- (void)initView
{
    //创建一个scrollView
    UIScrollView *headScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TableViewBottom)];
    headScrollView.tag=1002;
    headScrollView.contentSize=CGSizeMake(SCREEN_WIDTH*3, TableViewBottom);
    headScrollView.delegate=self;
    headScrollView.pagingEnabled=YES;
    headScrollView.showsHorizontalScrollIndicator=NO;
    headScrollView.showsVerticalScrollIndicator=NO;
    headScrollView.bounces=NO;
    [self.view addSubview:headScrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-25, TableViewBottom-30, 50, 20)];
    _pageControl.userInteractionEnabled=NO;
    _pageControl.numberOfPages=3;
    _pageControl.currentPage=0;
    [self.view addSubview:_pageControl];
    
    //创建手环圆圈的视图
    _bandCircleView=[[CircleView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, TableViewBottom-50)];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"imageColor"]];
    _bandCircleView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"imageColor"]];
    [headScrollView addSubview:_bandCircleView];
    
    //创建运动圆圈的视图
    _runCircleView=[[CircleView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 50, SCREEN_WIDTH, TableViewBottom-50)];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"imageColor"]];
    _runCircleView.type=1;
    _runCircleView.percent=0.7;
    _runCircleView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"imageColor"]];
    [headScrollView addSubview:_runCircleView];
    
    //创建体重圆圈的视图
    _weightCircleView=[[CircleView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 50, SCREEN_WIDTH, TableViewBottom-50)];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"imageColor"]];
    _weightCircleView.type=2;
    _weightCircleView.percent=0.5;
    _weightCircleView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"imageColor"]];
    [headScrollView addSubview:_weightCircleView];
    
    //创建weightButton
    UIButton *weightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [weightButton setTitle:@"记体重" forState:UIControlStateNormal];
    [weightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [weightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    weightButton.titleLabel.font=[UIFont systemFontOfSize:9];
    weightButton.frame=CGRectMake(3*SCREEN_WIDTH-40, TableViewBottom-50,60,20);
    weightButton.layer.cornerRadius=10;
    weightButton.backgroundColor=[UIColor grayColor];
    [weightButton addTarget:self action:@selector(weightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [headScrollView addSubview:weightButton];
    
    //title
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 30, 200, 30)];
    _titleLabel.text=@"未绑定手环";
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    //左边的button
    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"run_mi_logo"] forState:UIControlStateNormal];
    leftButton.frame=CGRectMake(15, 30, 20, 20);
    [leftButton addTarget:self action:@selector(leftButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    //右边的button
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"run_mi_logo"] forState:UIControlStateNormal];
    //[rightButton setTitle:@"..." forState:UIControlStateNormal];
    //[rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.frame=CGRectMake(SCREEN_WIDTH-35, 30, 20, 20);
    [rightButton addTarget:self action:@selector(rightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];

    //手环圆圈上的视图控件
    _sleepStateLabel=[[UILabel alloc]init];
    _sleepStateLabel.text=@"睡眠未更新";
    _sleepStateLabel.textColor=[UIColor lightGrayColor];
    _sleepStateLabel.font=[UIFont systemFontOfSize:12];
    _sleepStateLabel.textAlignment=NSTextAlignmentCenter;
    _sleepStateLabel.frame=CGRectMake(SCREEN_WIDTH/2-100, 160, 200, 20);
    [headScrollView addSubview:_sleepStateLabel];
    
    _timeLabel=[[UILabel alloc]init];
    _timeLabel.text=@"0小时00分";
    _timeLabel.textColor=[UIColor lightGrayColor];
    _timeLabel.font=[UIFont systemFontOfSize:23];
    _timeLabel.textAlignment=NSTextAlignmentCenter;
    _timeLabel.frame=CGRectMake(SCREEN_WIDTH/2-100, 180, 200, 30);
    [headScrollView addSubview:_timeLabel];
    
    _deepSleepLabel=[[UILabel alloc]init];
    _deepSleepLabel.text=@"深度睡眠0小时00分";
    _deepSleepLabel.textColor=[UIColor lightGrayColor];
    _deepSleepLabel.font=[UIFont systemFontOfSize:10];
    _deepSleepLabel.textAlignment=NSTextAlignmentCenter;
    _deepSleepLabel.frame=CGRectMake(SCREEN_WIDTH/2-100, 200, 200, 30);
    [headScrollView addSubview:_deepSleepLabel];
    
    //运动圆圈上的视图控件
    _stepStateLabel=[[UILabel alloc]init];
    _stepStateLabel.text=@"步数未更新";
    _stepStateLabel.textColor=[UIColor lightGrayColor];
    _stepStateLabel.font=[UIFont systemFontOfSize:12];
    _stepStateLabel.textAlignment=NSTextAlignmentCenter;
    _stepStateLabel.frame=CGRectMake(SCREEN_WIDTH+SCREEN_WIDTH/2-100, 160, 200, 20);
    [headScrollView addSubview:_stepStateLabel];
    
    _stepLabel=[[UILabel alloc]init];
    _stepLabel.text=@"步";
    _stepLabel.textColor=[UIColor lightGrayColor];
    _stepLabel.font=[UIFont systemFontOfSize:15];
    _stepLabel.textAlignment=NSTextAlignmentRight;
    _stepLabel.frame=CGRectMake(SCREEN_WIDTH+SCREEN_WIDTH/2-140, 185, 200, 20);
    _stepLabel.alpha=0;
    [headScrollView addSubview:_stepLabel];
    
    _stepNumLabel=[[UILabel alloc]init];
    _stepNumLabel.text=@"0000";
    _stepNumLabel.textColor=[UIColor lightGrayColor];
    _stepNumLabel.font=[UIFont systemFontOfSize:23];
    _stepNumLabel.textAlignment=NSTextAlignmentCenter;
    _stepNumLabel.frame=CGRectMake(SCREEN_WIDTH+SCREEN_WIDTH/2-100, 180, 200, 30);
    [headScrollView addSubview:_stepNumLabel];
    
    _stepDistanceLabel=[[UILabel alloc]init];
    _stepDistanceLabel.text=@"0米 | 0千卡";
    _stepDistanceLabel.textColor=[UIColor lightGrayColor];
    _stepDistanceLabel.font=[UIFont systemFontOfSize:10];
    _stepDistanceLabel.textAlignment=NSTextAlignmentCenter;
    _stepDistanceLabel.frame=CGRectMake(SCREEN_WIDTH+SCREEN_WIDTH/2-100, 200, 200, 30);
    [headScrollView addSubview:_stepDistanceLabel];
    
    //体重圆圈上的视图控件
    _kgLabel=[[UILabel alloc]init];
    _kgLabel.text=@"公斤";
    _kgLabel.textColor=[UIColor lightGrayColor];
    _kgLabel.font=[UIFont systemFontOfSize:12];
    _kgLabel.textAlignment=NSTextAlignmentRight;
    _kgLabel.frame=CGRectMake(2*SCREEN_WIDTH+SCREEN_WIDTH/2-150, 190, 200, 20);
    [headScrollView addSubview:_kgLabel];
    
    _weightNumLabel=[[UILabel alloc]init];
    _weightNumLabel.text=@"0.00";
    _weightNumLabel.textColor=[UIColor lightGrayColor];
    _weightNumLabel.font=[UIFont systemFontOfSize:23];
    _weightNumLabel.textAlignment=NSTextAlignmentCenter;
    _weightNumLabel.frame=CGRectMake(2*SCREEN_WIDTH+SCREEN_WIDTH/2-100, 180, 200, 30);
    [headScrollView addSubview:_weightNumLabel];
    
    _weightStateLabel=[[UILabel alloc]init];
    _weightStateLabel.text=@"-- --";
    _weightStateLabel.textColor=[UIColor lightGrayColor];
    _weightStateLabel.font=[UIFont systemFontOfSize:10];
    _weightStateLabel.textAlignment=NSTextAlignmentCenter;
    _weightStateLabel.frame=CGRectMake(2*SCREEN_WIDTH+SCREEN_WIDTH/2-100, 200, 200, 30);
    [headScrollView addSubview:_weightStateLabel];
    
    
    //创建tableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 350, SCREEN_WIDTH, SCREEN_HEIGHT-TableViewTop) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    UIView *seperateView=[[UIView alloc]init];
    seperateView.frame=CGRectMake(10, -2, SCREEN_WIDTH-20, 1);
    seperateView.backgroundColor=[UIColor lightGrayColor];
    [_tableView addSubview:seperateView];
    
    _downRefreshImageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, -35, 25, 25)];
    _downRefreshImageView.image=[UIImage imageNamed:@"pulldown@2x"];
    [_tableView addSubview:_downRefreshImageView];
    _downRefreshLabel=[[UILabel alloc]initWithFrame:CGRectMake(130, -43, 100, 25)];
    _downRefreshLabel.text=@"下拉同步手环数据";
    _downRefreshLabel.font=[UIFont systemFontOfSize:12];
    [_tableView addSubview:_downRefreshLabel];
    UILabel *downRemindLabel=[[UILabel alloc]initWithFrame:CGRectMake(130, -27, 100, 25)];
    downRemindLabel.text=@"今天尚未同步";
    downRemindLabel.textColor=[UIColor grayColor];
    downRemindLabel.font=[UIFont systemFontOfSize:10];
    [_tableView addSubview:downRemindLabel];
}





#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"identifier";
    UITableViewCell *cell=nil;
    cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.frame=CGRectMake(0, 0, SCREEN_WIDTH, 56);
        cell.selectionStyle=NO;
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 20, 10, 15)];
        imageView.image=[UIImage imageNamed:@"right"];
        [cell addSubview:imageView];
    }
    cell.textLabel.text=@"还没有绑定设备哦，点击绑定吧";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

#pragma mark -UIScrollViewDelegate

//这个方法实现了惯性滑动和分页滑动

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    if(scrollView.tag==1002)
    {
        int index=targetContentOffset->x/SCREEN_WIDTH;
        _pageControl.currentPage=index;
        if(index==2)
        {
            _titleLabel.text=@"未绑定体重秤";
        }else
        {
            _titleLabel.text=@"未绑定手环";
        }
        return;
    }
    //刷新数据
    if(scrollView.contentOffset.y<-55)
    {
        NSLog(@"数据刷新了");
        [_tableView reloadData];
    }
    
    //根据惯性滑动的效果
    //惯性滑动距离
    float inertiaDistance;
    //惯性滑动时间
    float inertiaTime;
    //手指离开屏幕的时候x和y方向的速度
    //NSLog(@"velocity:%@",NSStringFromCGPoint(velocity));
    //如果手指离开屏幕时的滑动速度>0.6,就滑动过去
   if(velocity.y>0.6)
   {
       inertiaDistance=_tableView.frame.origin.y-TableViewTop;
       //动画需要时间
       //(350-188)/2.0=distanc/time  全部距离/全部时间=剩余距离/剩余时间
       inertiaTime=2.0/(TableViewBottom-TableViewTop)*inertiaDistance;
       //开启动画
       [self animationTime:inertiaTime distance:TableViewBottom-TableViewTop];
       return;
       
   }else if (velocity.y<-0.6)
   {
       inertiaDistance=TableViewBottom-_tableView.frame.origin.y;
       //动画需要时间
       //(350-188)/2.0=distanc/time  全部距离/全部时间=剩余距离/剩余时间
       inertiaTime=2.0/(TableViewBottom-TableViewTop)*inertiaDistance;
       //开启动画
       [self animationTime:inertiaTime distance:0];
       return;
   }
   

    //类似翻页效果的自动滑动
    //临界值
    float criticalNum=(TableViewBottom-TableViewTop)/2+TableViewTop;
    //剩余距离
    float distance;
    //动画需要时间
    float time;
    if(_tableView.frame.origin.y<=criticalNum)
    {
        //剩余距离
        distance=_tableView.frame.origin.y-TableViewTop;
        //动画需要时间
        //(200-150)/2.0=distanc/time  全部距离/全部时间=剩余距离/剩余时间
        time=2.0/(350-183)*distance;
        //开启动画
        [self animationTime:time  distance:TableViewBottom-TableViewTop];
        
    }
    else if (_tableView.frame.origin.y>criticalNum)
    {
        //剩余距离
        distance=TableViewBottom-_tableView.frame.origin.y;
        //动画需要时间
        //(250-150)/2.0=distanc/time  全部距离/全部时间=剩余距离/剩余时间
        time=2.0/(350-183)*distance;
        //开启动画
        [self animationTime:time distance:0];
    }
    

}

//这个方法实现了向上滑动时tableView是否跟随
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(scrollView.tag==1002)
    {
        
        return;
    }
 //下拉刷新的文字变换
    if(scrollView.contentOffset.y<-55)
    {
        _downRefreshImageView.image=[UIImage imageNamed:@"pullup@2x"];
        _downRefreshLabel.text=@"释放开始同步数据";
    }
    if(scrollView.contentOffset.y>-30)
    {
        _downRefreshImageView.image=[UIImage imageNamed:@"pulldown@2x"];
        _downRefreshLabel.text=@"下拉同步手环数据";
    }
    //判断是向上还是向下滑动
    if(scrollView.contentOffset.y>_lastContentOffset)
    {
    //向上滑动，tableView起始高度不能小于183
    if (_tableView.frame.origin.y>TableViewTop) {
        //移动距离
        float distance=scrollView.contentOffset.y-_lastContentOffset;
        //还没到顶，继续滑动，contentOffset保持不动
        [scrollView setContentOffset:CGPointMake(0, _lastContentOffset) animated:NO];
        //tableView向上移动
        _tableView.frame=CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y-distance, _tableView.frame.size.width, _tableView.frame.size.height);
        
        
    }else
    {
        _tableView.frame=CGRectMake(_tableView.frame.origin.x, TableViewTop, _tableView.frame.size.width, _tableView.frame.size.height);
        //已经到顶,记录tableView的滑动位置
        _lastContentOffset=scrollView.contentOffset.y;
        //防止反弹回来的时候造成异常，上次滑动位置不得大于最大滑动量
        if (scrollView.contentOffset.y>scrollView.contentSize.height-_tableView.frame.size.height) {
            _lastContentOffset=scrollView.contentSize.height-_tableView.frame.size.height;
            if (_lastContentOffset<0) {
                _lastContentOffset=0;
            }
            //NSLog(@"content%f height%f",scrollView.contentSize.height,_tableView.frame.size.height);
        }
    }
    }else if (scrollView.contentOffset.y<_lastContentOffset)
    {
        //向下滑动，tableView起始高度不能大于350
        if (_tableView.frame.origin.y<TableViewBottom) {
            //还没到底，继续滑动
            //移动距离
            float distance=_lastContentOffset-scrollView.contentOffset.y;
            //让contentOffset保持不动
            [scrollView setContentOffset:CGPointMake(0, _lastContentOffset) animated:NO];
            //tableView向下滑动
            _tableView.frame=CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y+distance, _tableView.frame.size.width, _tableView.frame.size.height);
        }else
        {
            _tableView.frame=CGRectMake(_tableView.frame.origin.x, TableViewBottom, _tableView.frame.size.width, _tableView.frame.size.height);
            //已经到底，记录滑动的位置
            _lastContentOffset=scrollView.contentOffset.y;
            //防止反弹回来的时候造成异常，上次滑动位置不得小于0
            if (scrollView.contentOffset.y<0) {
                _lastContentOffset=0;
            }
            
        }

    }

    NSLog(@"contentOffset:%f tableViewOriginY:%f",scrollView.contentOffset.y,_tableView.frame.origin.y);
    
    //图片的缩放
    //总的移动距离
    CGFloat distanceAll = TableViewBottom-TableViewTop;
    //移动距离 向上的过程是不断变大的
    float distance=TableViewBottom-_tableView.frame.origin.y;
    //circleView需要向上移动70的距离
    
    //图片视图只在正确的区间改变
    if(_tableView.frame.origin.y>=TableViewTop&&_tableView.frame.origin.y<=TableViewBottom)
    {
        
    //修改bandCircleView的frame
    _bandCircleView.frame = CGRectMake(0, 50+distance-distance/distanceAll*70, SCREEN_WIDTH, TableViewBottom-50-2*distance);
        //修改alpha
        _bandCircleView.alpha=1-distance/(distanceAll-12);
        //修改第一个圆圈内label的值
        _sleepStateLabel.frame=CGRectMake(SCREEN_WIDTH/2-100, 160-distance/distanceAll*70, 200, 20);
        _sleepStateLabel.alpha=1-distance/distanceAll;
        _timeLabel.frame=CGRectMake(SCREEN_WIDTH/2-100, 180-distance/distanceAll*70, 200, 30);
        _deepSleepLabel.frame=CGRectMake(SCREEN_WIDTH/2-100, 200-distance/distanceAll*70, 200, 30);
        _deepSleepLabel.alpha=1-distance/distanceAll;
        
        //修改runCircleView的frame
        _runCircleView.frame = CGRectMake(SCREEN_WIDTH, 50+distance-distance/distanceAll*70, SCREEN_WIDTH, TableViewBottom-50-2*distance);
        //修改alpha
        _runCircleView.alpha=1-distance/(distanceAll-12);
        //修改run圆圈内label的值
        _stepStateLabel.frame=CGRectMake(SCREEN_WIDTH+SCREEN_WIDTH/2-100, 160-distance/distanceAll*70, 200, 20);
        _stepStateLabel.alpha=1-distance/distanceAll;
        _stepNumLabel.frame=CGRectMake(SCREEN_WIDTH+SCREEN_WIDTH/2-100, 180-distance/distanceAll*70, 200, 30);
        _stepDistanceLabel.frame=CGRectMake(SCREEN_WIDTH+SCREEN_WIDTH/2-100, 200-distance/distanceAll*70, 200, 30);
        _stepDistanceLabel.alpha=1-distance/distanceAll;
        _stepLabel.frame=CGRectMake(SCREEN_WIDTH+SCREEN_WIDTH/2-140, 185-distance/distanceAll*70, 200, 20);
        _stepLabel.alpha=distance/distanceAll;
        
        //修改weightCircleView的frame
        _weightCircleView.frame = CGRectMake(2*SCREEN_WIDTH, 50+distance-distance/distanceAll*70, SCREEN_WIDTH, TableViewBottom-50-2*distance);
        //修改alpha
        _weightCircleView.alpha=1-distance/(distanceAll-12);
        //修改weight圆圈内label的值
        _kgLabel.frame=CGRectMake(2*SCREEN_WIDTH+SCREEN_WIDTH/2-150, 190-distance/distanceAll*70, 200, 20);
        
        _weightNumLabel.frame=CGRectMake(2*SCREEN_WIDTH+SCREEN_WIDTH/2-100, 180-distance/distanceAll*70, 200, 30);
        _weightStateLabel.frame=CGRectMake(2*SCREEN_WIDTH+SCREEN_WIDTH/2-100, 200-distance/distanceAll*70, 200, 30);
        _weightStateLabel.alpha=1-distance/distanceAll;
        
    }
    
}


- (void)animationTime:(float)time distance:(float)distance
{
    //总的移动距离
    CGFloat distanceAll = TableViewBottom-TableViewTop;
    //开启动画
    [UIView beginAnimations:@"animation" context:nil];
    //动画时间
    [UIView setAnimationDuration:time];
    //tableView的动画结束位置
    _tableView.frame=CGRectMake(0, TableViewBottom-distance, SCREEN_WIDTH, SCREEN_HEIGHT-TableViewTop);
    ////修改bandCircleView的frame
    _bandCircleView.frame = CGRectMake(0, 50+distance-distance/distanceAll*70, SCREEN_WIDTH, TableViewBottom-50-2*distance);
    //修改alpha
    _bandCircleView.alpha=1-distance/(distanceAll-12);
    //修改第一个圆圈内label的值
    _sleepStateLabel.frame=CGRectMake(SCREEN_WIDTH/2-100, 160-distance/distanceAll*70, 200, 20);
    _sleepStateLabel.alpha=1-distance/distanceAll;
    _timeLabel.frame=CGRectMake(SCREEN_WIDTH/2-100, 180-distance/distanceAll*70, 200, 30);
    _deepSleepLabel.frame=CGRectMake(SCREEN_WIDTH/2-100, 200-distance/distanceAll*70, 200, 30);
    _deepSleepLabel.alpha=1-distance/distanceAll;
    
    //修改runCircleView的frame
    _runCircleView.frame = CGRectMake(SCREEN_WIDTH, 50+distance-distance/distanceAll*70, SCREEN_WIDTH, TableViewBottom-50-2*distance);
    //修改alpha
    _runCircleView.alpha=1-distance/(distanceAll-12);
    //修改run圆圈内label的值
    _stepStateLabel.frame=CGRectMake(SCREEN_WIDTH+SCREEN_WIDTH/2-100, 160-distance/distanceAll*70, 200, 20);
    _stepStateLabel.alpha=1-distance/distanceAll;
    _stepNumLabel.frame=CGRectMake(SCREEN_WIDTH+SCREEN_WIDTH/2-100, 180-distance/distanceAll*70, 200, 30);
    _stepDistanceLabel.frame=CGRectMake(SCREEN_WIDTH+SCREEN_WIDTH/2-100, 200-distance/distanceAll*70, 200, 30);
    _stepDistanceLabel.alpha=1-distance/distanceAll;
    _stepLabel.frame=CGRectMake(SCREEN_WIDTH+SCREEN_WIDTH/2-140, 185-distance/distanceAll*70, 200, 20);
    _stepLabel.alpha=distance/distanceAll;
    
    //修改weightCircleView的frame
    _weightCircleView.frame = CGRectMake(2*SCREEN_WIDTH, 50+distance-distance/distanceAll*70, SCREEN_WIDTH, TableViewBottom-50-2*distance);
    //修改alpha
    _weightCircleView.alpha=1-distance/(distanceAll-12);
    //修改weight圆圈内label的值
    _kgLabel.frame=CGRectMake(2*SCREEN_WIDTH+SCREEN_WIDTH/2-150, 190-distance/distanceAll*70, 200, 20);
    
    _weightNumLabel.frame=CGRectMake(2*SCREEN_WIDTH+SCREEN_WIDTH/2-100, 180-distance/distanceAll*70, 200, 30);
    _weightStateLabel.frame=CGRectMake(2*SCREEN_WIDTH+SCREEN_WIDTH/2-100, 200-distance/distanceAll*70, 200, 30);
    _weightStateLabel.alpha=1-distance/distanceAll;
    
    //结束动画
    [UIView commitAnimations];
}
- (void)buttonAnimation:(UIButton *)button
{
    NSInteger tag=button.tag;
    NSLog(@"%@按钮点击了",_nameArray[tag]);
    for (int i=0; i<=8; i++) {
        if (i==8) {
            /*
            //开启动画
            [UIView beginAnimations:nil context:nil];
            //动画时间
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelay:0.2*i];
            _listView.frame=CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            [UIView commitAnimations];
             */
            [UIView animateWithDuration:0.3 delay:0.2*i options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _listView.frame=CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                [_listView removeFromSuperview];
            }];
        }else
        {
        UIView *view=_buttonViewArray[7-i];
            /*
        //开启动画
        [UIView beginAnimations:nil context:nil];
        //动画时间
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.2*i];
        view.frame=CGRectMake(0, -45, SCREEN_WIDTH, 45);
        [UIView commitAnimations];
             */
            [UIView animateWithDuration:0.3 delay:0.2*i options:UIViewAnimationOptionCurveEaseInOut animations:^{
                view.frame=CGRectMake(0, -45, SCREEN_WIDTH, 45);
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }

    }
}

#pragma mark ButtonTouch

- (void)leftButtonTouch
{
    NSLog(@"左边的按钮点击了");
}

- (void)rightButtonTouch
{
    NSLog(@"右边的按钮点击了");
    _buttonViewArray=nil;
    _buttonViewArray=[NSMutableArray array];
    for (int i=0; i<8; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=i;
        if (i<7) {
        button.frame=CGRectMake(0, 0, SCREEN_WIDTH, 45);
        [button setTitle:_nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //button.titleLabel.textAlignment=NSTextAlignmentRight;
        button.titleLabel.font=[UIFont systemFontOfSize:15];
            if (i<4) {
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -255, 0, 0)];
            }else
            {
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -230, 0, 0)];
            }
        }else
        {
            button.frame=CGRectMake(SCREEN_WIDTH-40, 6, 32, 32);
            [button setImage:[UIImage imageNamed:@"turn_off_button@2x"] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(buttonAnimation:) forControlEvents:UIControlEventTouchUpInside];
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, -45, SCREEN_WIDTH, 45)];
        UIView *seperateView=[[UIView alloc]initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH-30, 1)];
        seperateView.backgroundColor=[UIColor grayColor];
        [view addSubview:seperateView];
        [view addSubview:button];
        [_buttonViewArray addObject:view];
        
    }

    //开启动画
    _listView=nil;
    _listView=[[UIView alloc]init];
    _listView.frame=CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    _listView.alpha=0.9;
    _listView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_listView];
    //阴影图片
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 340, SCREEN_WIDTH, 45)];
    imageView.image=[UIImage imageNamed:@"code_light"];
    [_listView addSubview:imageView];
    [UIView animateWithDuration:0.5 animations:^{
        _listView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        for (int i=0; i<8; i++) {
        UIView *view=_buttonViewArray[i];
        //view.backgroundColor=[UIColor blueColor];
        [_listView addSubview:view];
        //开启动画
        [UIView beginAnimations:nil context:nil];
        //动画时间
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.2*i];
        view.frame=CGRectMake(0, 330-45*i, SCREEN_WIDTH, 45);
        [UIView commitAnimations];
        }
    }];
    
    
}

- (void)weightButtonTouch
{
    NSLog(@"记录体重的按钮点击了");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ARSCNViewController.m
//  ASignARDemo
//
//  Created by chenxi on 2017/12/8.
//  Copyright © 2017年 chenxi. All rights reserved.
//

#import "ARSCNViewController.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface ARSCNViewController () <ARSCNViewDelegate>

@property(nonatomic,strong)ARSCNView *arSCNView;
@property(nonatomic,strong)ARSession *arSession;
@property(nonatomic,strong)ARWorldTrackingConfiguration *arWorldTrackingConfiguration;
@property(nonatomic,strong)SCNNode *planeNode;

@end

@implementation ARSCNViewController

- (ARWorldTrackingConfiguration *)arWorldTrackingConfiguration{
    if (_arWorldTrackingConfiguration != nil) {
        return _arWorldTrackingConfiguration;
    }
    _arWorldTrackingConfiguration = [ARWorldTrackingConfiguration new];
    _arWorldTrackingConfiguration.planeDetection = ARPlaneDetectionHorizontal;
    _arWorldTrackingConfiguration.lightEstimationEnabled = YES;
    return _arWorldTrackingConfiguration;
}

- (ARSession *)arSession{
    if (_arSession != nil) {
        return _arSession;
    }
    _arSession = [[ARSession alloc]init];
    return _arSession;
}

- (ARSCNView *)arSCNView{
    if (_arSCNView != nil) {
        return _arSCNView;
    }
        _arSCNView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        _arSCNView.session = self.arSession;
        _arSCNView.delegate = self;
        _arSCNView.automaticallyUpdatesLighting = YES;
        return _arSCNView;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    SCNScene *scnScene = [SCNScene sceneNamed:@"Models.scnassets/senlin.dae"];
//    self.arSCNView.scene = scnScene;
//    SCNNode *shipNode = scnScene.rootNode.childNodes[0];
//    [self.arSCNView.scene.rootNode addChildNode:shipNode];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view addSubview:self.arSCNView];
//    self.arSCNView.showsStatistics = YES;
    [self.arSession runWithConfiguration:self.arWorldTrackingConfiguration];
    
    //添加返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.frame = CGRectMake(self.view.bounds.size.width/2-50, self.view.bounds.size.height-100, 100, 50);
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    if ([anchor isMemberOfClass: [ARPlaneAnchor class]]) {
        NSLog(@"捕捉到平地");
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x*0.5 height:0 length:planeAnchor.extent.x * 0.5 chamferRadius:0];
        plane.firstMaterial.diffuse.contents = [UIColor redColor];
        
        SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
        planeNode.position = SCNVector3Make(planeAnchor.center.x , 0, planeAnchor.center.z);
        [node addChildNode:planeNode];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/senlin.dae"];
            SCNNode *vaseNode = scene.rootNode.childNodes[0];
            vaseNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
            [node addChildNode:vaseNode];
            self.arSCNView.scene = scene;
        });
    }
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera{
    
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    NSLog(@"相机移动");
    //移动 机
    if (self.planeNode) {
        //捕捉相机的位置，让节点随着相机移动 移动 //根据官  档记录，相机的位置参数在4X4矩阵的第三
        self.planeNode.position =SCNVector3Make(frame.camera.transform.columns[3]
                                                .x,frame.camera.transform.columns[3].y,frame.camera.transform.columns[3].z);
    }
}
@end

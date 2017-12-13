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
    self.arSCNView.showsStatistics = YES;
    self.arSCNView.delegate = self;
    [self.arSession runWithConfiguration:self.arWorldTrackingConfiguration];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    if ([anchor isMemberOfClass: [ARPlaneAnchor class]]) {
        NSLog(@"捕捉到平地");
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x*0.3 height:0.01 length:planeAnchor.extent.x * 0.3 chamferRadius:0];
        plane.firstMaterial.diffuse.contents = [UIColor redColor];
        
        SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
        planeNode.position = SCNVector3Make(planeAnchor.center.x , 0, planeAnchor.center.z);
        [node addChildNode:planeNode];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SCNScene *scene = [SCNScene sceneNamed:@"Models.scnassets/senlin.dae"];
            SCNNode *vaseNode = scene.rootNode.childNodes[0];
            vaseNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
            [node addChildNode:vaseNode];
        });
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

# swift

swift版可以处理引导页是视频或者是图片的封装，在
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
中先判断该app版本是不是第一次使用，然后加入下面的代码，就OK啦

let videoPath = Bundle.main.path(forResource: "qidong", ofType: "mp4")

let nav = UINavigationController.init(rootViewController: ViewController())

let guideVc = JSGuideController.init(guide: .picture, pictures: ["guide_1","guide_2","guide_3"], videoPath: nil,pushViewController:nav)

//let guideVc = JSGuideController.init(guide: .video, pictures: nil, videoPath: videoPath,pushViewController:nav)

self.window?.rootViewController = guideVc

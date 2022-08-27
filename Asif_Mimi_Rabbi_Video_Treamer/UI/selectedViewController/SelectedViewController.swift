//
//  SelectedViewController.swift
//  Asif_Mimi_Rabbi_Video_Treamer
//
//  Created by Asif Rabbi on 7/8/22.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos

class SelectedViewController: UIViewController {
    
    var isPlaying = true
    var isSliderEnd = true
    
    let exportSession: AVAssetExportSession! = nil
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    var asset: AVAsset!
    
    var url:NSURL! = nil
    var startTime: CGFloat = 0.0
    var stopTime: CGFloat  = 0.0
    var thumbTime: CMTime!
    var thumbtimeSeconds: Int!
    
    var videoPlaybackPosition: CGFloat = 0.0
    
    var cache:NSCache<AnyObject, AnyObject>!
    var rangSlider: RangeSlider! = nil
    
    let composition = AVMutableComposition()
    
    var arrayImage = ["angry_emoji", "confuse_emoji", "crying_emoji", "sad_emoji", "thinking_emoji", "tounge_emoji", "angry_emoji", "confuse_emoji", "crying_emoji", "sad_emoji"]
    
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageFrameView: UIView!
    @IBOutlet weak var playPauseBtnHolderView: UIView!
    
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var playPauseBtn: UIButton!
    
    @IBOutlet weak var StickerCollectionView: UICollectionView!
    
    var startTimestr = ""
    var endTimestr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadViews()
        
        StickerCollectionView.collectionViewLayout = layout()
        StickerCollectionView.register(EmojiCollectionViewCell.nib(), forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        
        if asset != nil {
            
            thumbTime = asset.duration
            thumbtimeSeconds = Int(CMTimeGetSeconds(thumbTime))
            
            endTimeLbl.text = "\(String(Double(thumbtimeSeconds)).prefix(4))" + " s"
            
            self.viewAfterVideoIsPicked()
            
            let item:AVPlayerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: item)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = videoPlayerView.bounds
            
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnvideoPlayerView))
            self.videoPlayerView.addGestureRecognizer(tap)
            self.tapOnvideoPlayerView(tap: tap)
            
            videoPlayerView.layer.addSublayer(playerLayer)
            player.play()
        }
    }
    
    func layout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize (
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets.leading = 20
                
                let groupSize = NSCollectionLayoutSize (
                    widthDimension: .fractionalWidth(0.2),
                    heightDimension: .absolute(60)
                )
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                group.interItemSpacing = .fixed(1)
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.interGroupSpacing = 0
                
                section.orthogonalScrollingBehavior = .continuous
                
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerItemSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [headerItem]
                
                return section
                
            } else if sectionIndex == 1 {
                
                let itemSize = NSCollectionLayoutSize (
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets.leading = 20
                
                let groupSize = NSCollectionLayoutSize (
                    widthDimension: .fractionalWidth(0.2),
                    heightDimension: .absolute(60)
                )
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                group.interItemSpacing = .fixed(1)
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.interGroupSpacing = 0
                
                section.orthogonalScrollingBehavior = .continuous
                
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerItemSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [headerItem]
                
                return section
                
            }
            
            let itemSize = NSCollectionLayoutSize (
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(200)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize (
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(200)
            )
            
            let columns = environment.container.contentSize.width > 500 ? 2 : 1
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            if columns > 1 {
                group.contentInsets.leading = 20
                group.contentInsets.trailing = 20
            }
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.interGroupSpacing = 20
            section.contentInsets.bottom = 20
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [headerItem]
            
            
            return section
            
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        
        return layout
    }
    
    func loadViews() {
        
        playPauseBtnHolderView.layer.cornerRadius = playPauseBtnHolderView.frame.size.width/2
        playPauseBtn.setTitle("", for: .normal)
        
        saveBtn.layer.cornerRadius = 5.0
        saveBtn.isHidden = false
        containerView.isHidden = true
        
        imageFrameView.layer.cornerRadius = 5.0
        imageFrameView.layer.borderWidth = 1.0
        imageFrameView.layer.borderColor = UIColor.white.cgColor
        imageFrameView.layer.masksToBounds = true
        
        player = AVPlayer()
        
        //Allocating NsCahe for temp storage
        self.cache = NSCache()
        
    }
    
    
    @IBAction func trimVideoBtn(_ sender: UIButton) {
        let start = Float(startTimestr)
        let end = Float(endTimestr)
        
        self.cropVideo(sourceURL1: url, startTime: start!, endTime: end!)
        
        self.dismiss(animated: true, completion: nil)
        Toast.sharedInstance.isToastAvailable = true
    }
    
    @IBAction func closeWindow(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playPauseBtn(_ sender: UIButton){
        if isPlaying {
            self.player.play()
        }
        else {
            self.player.pause()
        }
        isPlaying = !isPlaying
    }
}

//Subclass of VideoMainViewController
extension SelectedViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func viewAfterVideoIsPicked() {
        //removing player
        if(playerLayer != nil) {
            playerLayer.removeFromSuperlayer()
        }
        
        self.createImageFrames()
        
        saveBtn.isHidden = false
        containerView.isHidden = false
        
        isSliderEnd = true
        startTimestr = "\(0.0)"
        endTimestr = "\(thumbtimeSeconds!)"
        self.createrangSlider()
    }
    
    //Tap action on video player
    @objc func tapOnvideoPlayerView(tap: UITapGestureRecognizer) {
        if isPlaying {
            self.player.play()
        }
        else {
            self.player.pause()
        }
        isPlaying = !isPlaying
    }
    
    //MARK: CreatingFrameImages
    func createImageFrames() {
        //creating assets
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.requestedTimeToleranceAfter = CMTime.zero;
        assetImgGenerate.requestedTimeToleranceBefore = CMTime.zero;
        
        
        assetImgGenerate.appliesPreferredTrackTransform = true
        let thumbTime: CMTime = asset.duration
        let thumbtimeSeconds = Int(CMTimeGetSeconds(thumbTime))
        let maxLength = "\(thumbtimeSeconds)" as NSString
        
        let thumbAvg = thumbtimeSeconds/6
        var startTime = 1
        var startXPosition:CGFloat = 0.0
        
        //loop for 6 number of frames
        for _ in 0...7 {
            
            let imageButton = UIButton()
            let xPositionForEach = CGFloat(self.imageFrameView.frame.width)/6
            imageButton.frame = CGRect(x: CGFloat(startXPosition), y: CGFloat(0), width: xPositionForEach, height: CGFloat(self.imageFrameView.frame.height))
            
            do {
                let time:CMTime = CMTimeMakeWithSeconds(Float64(startTime),preferredTimescale: Int32(maxLength.length))
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: img)
                imageButton.setImage(image, for: .normal)
            } catch _ as NSError {
                print("Image generation failed with error (error)")
            }
            
            startXPosition = startXPosition + xPositionForEach
            startTime = startTime + thumbAvg
            imageButton.isUserInteractionEnabled = false
            imageFrameView.addSubview(imageButton)
        }
        
    }
    
    //Create range slider
    func createrangSlider() {
        //remove slider
        let subViews = self.containerView.subviews
        for subview in subViews{
            if subview.tag == 1000 {
                subview.removeFromSuperview()
            }
        }
        
        rangSlider = RangeSlider(frame: containerView.bounds)
        containerView.addSubview(rangSlider)
        rangSlider.tag = 1000
        
        //Range slider action
        rangSlider.addTarget(self, action: #selector(SelectedViewController.rangSliderValueChanged(_:)), for: .valueChanged)
        
        let time = DispatchTime.now() + Double(Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.rangSlider.trackHighlightTintColor = UIColor.clear
            self.rangSlider.curvaceousness = 1.0
        }
    }
    
    //MARK: rangSlider Delegate
    @objc func rangSliderValueChanged(_ rangSlider: RangeSlider) {
        
        if(isSliderEnd == true) {
            rangSlider.minimumValue = 0.0
            rangSlider.maximumValue = Double(thumbtimeSeconds)
            
            rangSlider.upperValue = Double(thumbtimeSeconds)
            isSliderEnd = !isSliderEnd
        }
        
        startTimestr = "\(rangSlider.lowerValue)"
        endTimestr = "\(rangSlider.upperValue)"
        
        print("Start Time: =====",startTimestr)
        print("End Time: ====", endTimestr)
        
        startTimeLbl.text = "\(startTimestr.prefix(4))" + " s"
        endTimeLbl.text = "\(endTimestr.prefix(4))" + " s"
        
        print(rangSlider.lowerLayerSelected)
        
        if(rangSlider.lowerLayerSelected) {
            self.seekVideo(toPos: CGFloat(rangSlider.lowerValue))
            
        }else {
            self.seekVideo(toPos: CGFloat(rangSlider.upperValue))
        }
        
        print(startTime)
    }
    //Seek video when slide
    func seekVideo(toPos pos: CGFloat) {
        self.videoPlaybackPosition = pos
        let time: CMTime = CMTimeMakeWithSeconds(Float64(self.videoPlaybackPosition), preferredTimescale: self.player.currentTime().timescale)
        self.player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        
        if(pos == CGFloat(thumbtimeSeconds)) {
            self.player.pause()
        }
    }
    
    private func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
       let size = track.naturalSize.applying(track.preferredTransform)
       return CGSize(width: abs(size.width), height: abs(size.height))
    }
    func initAspectRatioOfVideo(with fileURL: URL) -> Double {
      let resolution = resolutionForLocalVideo(url: fileURL)
      guard let width = resolution?.width, let height = resolution?.height else {
         return 0
      }
      return Double(height / width)
    }

    func textOverlay(url: URL) {
        let vidAsset = AVURLAsset(url: url, options: nil)

        // get video track
        let vtrack =  vidAsset.tracks(withMediaType: AVMediaType.video)
        
        let videoTrack: AVAssetTrack = vtrack[0]
        let size = videoTrack.naturalSize
        
        let resolution = resolutionForLocalVideo(url: url)
        guard let width = resolution?.width, let height = resolution?.height else { return }
        
        let titleLayer = CATextLayer()
        titleLayer.backgroundColor = UIColor.white.cgColor
        titleLayer.string = "Dummy text hjh hbbbkjhbk bhbjbkjhbkhjb hbkhbkjhbjk bhbkhbu"
        titleLayer.font = UIFont(name: "Helvetica", size: 28)
        titleLayer.shadowOpacity = 0.5
        titleLayer.alignmentMode = CATextLayerAlignmentMode.center
        titleLayer.frame = CGRect(x: 0, y: 50, width: width, height: height / 6)


        let videolayer = CALayer()
        videolayer.frame = CGRect(x: 0, y: 0, width: width, height: height)

        let parentlayer = CALayer()
        parentlayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        parentlayer.addSublayer(videolayer)
        parentlayer.addSublayer(titleLayer)

        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        layercomposition.renderSize = size
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videolayer, in: parentlayer)

        // instruction for watermark
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: composition.duration)
        let videotrack = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
        let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
        instruction.layerInstructions = NSArray(object: layerinstruction) as [AnyObject] as! [AVVideoCompositionLayerInstruction]
        layercomposition.instructions = NSArray(object: instruction) as [AnyObject] as! [AVVideoCompositionInstructionProtocol]

        //  create new file to receive data
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        let movieFilePath = docsDir.appendingPathComponent("result.mov")
        let movieDestinationUrl = NSURL(fileURLWithPath: movieFilePath)

        // use AVAssetExportSession to export video
        let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality)
        assetExport?.outputFileType = AVFileType.mov
        assetExport?.videoComposition = layercomposition

        // Check exist and remove old file
        FileManager.default.removeItemIfExisted(movieDestinationUrl as URL)

        assetExport?.outputURL = movieDestinationUrl as URL
        assetExport?.exportAsynchronously(completionHandler: {
            switch assetExport!.status {
            case AVAssetExportSession.Status.failed:
                print("failed")
                print(assetExport?.error ?? "unknown error")
            case AVAssetExportSession.Status.cancelled:
                print("cancelled")
                print(assetExport?.error ?? "unknown error")
            default:
                print("Movie complete")

//                self.myurl = movieDestinationUrl as URL
                self.saveToCameraRoll(URL: movieDestinationUrl as NSURL)
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: movieDestinationUrl as URL)
                }) { saved, error in
                    if saved {
                        print("Saved")
                    }
                }
            }
        })

    }
    
    
    
    
    
    //Trim Video Function
    func cropVideo(sourceURL1: NSURL, startTime:Float, endTime:Float) {
        
        let manager = FileManager.default
        
        guard let documentDirectory = try? manager.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: true) else {return}
        guard let mediaType = ("mp4" as? String) else {return}
        guard (sourceURL1 as? NSURL) != nil else {return}
        
        if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String {
            
            let length = Float(asset.duration.value) / Float(asset.duration.timescale)
            
            print("video length: \(length) seconds")
            
            let start = startTime
            let end = endTime
            print(documentDirectory)
            var outputURL = documentDirectory.appendingPathComponent("output")
            
            do {
                try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
                outputURL = outputURL.appendingPathComponent("1.mp4")
            }catch let error {
                print(error)
            }
            
            //Remove existing file
            _ = try? manager.removeItem(at: outputURL)
            
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
            exportSession.outputURL = outputURL
            exportSession.outputFileType = AVFileType.mp4
            
            let startTime = CMTime(seconds: Double(start ), preferredTimescale: 1000)
            let endTime = CMTime(seconds: Double(end ), preferredTimescale: 1000)
            let timeRange = CMTimeRange(start: startTime, end: endTime)
            
            exportSession.timeRange = timeRange
            exportSession.exportAsynchronously{
                switch exportSession.status {
                case .completed:
                    print("exported at \(outputURL)")
                    self.saveToCameraRoll(URL: outputURL as NSURL?)
                    Toast.sharedInstance.message = "Exported successfully"
                case .failed:
                    print("failed \(String(describing: exportSession.error))")
                    Toast.sharedInstance.message = "Exportation failed"
                case .cancelled:
                    print("cancelled \(String(describing: exportSession.error))")
                    Toast.sharedInstance.message = "Exportation cancelled"
                default: break
                }
                
            }
            
        }
        
    }
    
    //Save Video to Photos Library
    func saveToCameraRoll(URL: NSURL!) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL as URL) }) { saved, error in
                
                if saved {
                    let alertController = UIAlertController(title: "Cropped video was saved successfully", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        
    }
}



extension SelectedViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return arrayImage.count
        }else if section == 1{
            return arrayImage.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0{
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as! EmojiCollectionViewCell
            item.reload(imageName: arrayImage[indexPath.row])

            return item
        }else if indexPath.section == 1{
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as! EmojiCollectionViewCell
            item.reload(imageName: arrayImage[indexPath.row])

            return item
        }
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        item.backgroundColor = .green
        return item
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        
//        let cell = collectionView.dequeueReusableSupplementaryView(
//            ofKind: kind,
//            withReuseIdentifier: HeaderCollectionReusableView.identifier,
//            for: indexPath
//        ) as! HeaderCollectionReusableView
//        
//        cell.setUp(leftTitleLbl: arrayHeader[indexPath.section])
//        return cell
//    }
}

//
//  AppDelegate.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 10.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: "Root", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        
        let lectures = [LectureDocument(id: "IMCUP", shortName: "IMCUP", name: "Imagine Cup", color: .turquoise)]
        let lectureStore = LectureStore.lectures
        lectureStore.deleteAll()
        try! lectureStore.save(lectures)
        
        /*
        let fragments = [
            TranscriptFragment(content: "Frequency is the number of occurrences of a repeating event per unit of time. It is also referred to as temporal frequency, which emphasizes the contrast to spatial frequency and angular frequency. The period is the duration of time of one cycle in a repeating event, so the period is the reciprocal of the frequency. For example: if a newborn baby's heart beats at a frequency of 120 times a minute, its period—the time interval between beats—is half a second.", isFavourite: false, tags: [TranscriptTag(name: .marking, range: NSRange(location: 0, length: 5)), TranscriptTag(name: .keyword, range: NSRange(location: 10, length: 5))]),
            TranscriptFragment(content: "Frequency is an important parameter used in science and engineering to specify the rate of oscillatory and vibratory phenomena, such as mechanical vibrations, audio signals, radio waves, and light.", isFavourite: true)
                         ];
        */
        
        var fragments = [
            TranscriptFragment(content: "Hello, everybody my name is Todd Morrall. I'll get into that in just a second. But what I'm going to do now, what I'm going to do for the next few minutes is walk you through some tools that you can use in the future. So let me just make clear about what I'm going to do. So you're here on Imagine Cup. You're going to be pitching tomorrow and trying to convince the audience that what you have is interesting that it works, and that it will be useful.", isFavourite: false, tags: [TranscriptTag(name: .keyword, range: NSRange(location: 35, length: 12)), TranscriptTag(name: .keyword, range: NSRange(location: 297, length: 11))]),
            TranscriptFragment(content: "The reason that it's important, that you should pay attention is because startups don't fail from a lack of technology. Yeah, sure occasionally technology doesn't work out, but 90% of the time it's because of customers. They don't have customers and that's why they can't sell the product, not because they don't have a product. The real world doesn't really care if you got really cool technology, sure occasionally technology wins the game, but...", isFavourite: true),
            TranscriptFragment(content: "How many of you know what the business model canvas is? This is a business plan on one page. It's simply a tool. It's a scratchpad. It's a nice scratch pad, a chalkboard. It does not solve the world's problems. But what it is, is a really good way to keep track of all your business. Looks like it's a place to record your hypothesis, your guesses and then scratch them out and write new ones. As you go forward. As you go through things and what I'm gonna do is give you a tour of the business model canvas in just a minute, but also the way you can start.", isFavourite: true),
            TranscriptFragment(content: "But what it is, is a really good way to keep track of all your business. Looks like it's a place to record your hypothesis, your guesses and then scratch them out and write new ones. As you go forward. As you go through things and what I'm gonna do is give you a tour of the business model canvas in just a minute, but also the way you can start.", isFavourite: false),
            TranscriptFragment(content: "Quantitative survey methodology is a way of going out and talking to people in essence. It's an indirect interview method. You learn things from people by asking them different questions than the one you actually want the answer to, but by listening to the way they answer and what they say you can figure out what they want and part of this is to understand your customer ecosystem.", isFavourite: true),
        ];
        
        var transcript = TranscriptDocument(id:"1", title: "Todd Pitch", sequence: 1, fragments: fragments, lectureId: "IMCUP")
        let store = TranscriptStore.transcripts
        store.deleteAll()
        try! store.save(transcript)
        
        fragments = [
            TranscriptFragment(content: "Hello everybody, I’m now at UC Berkeley Business School writing their entrepreneurship program. OK, so today, we're going to talk about building a minimum viable product. So Todd talked about doing customer discovery. This is a tool to help you do that. Who has heard of minimum viable product?. It is not a prototype. The MVP can even something be a scribble on a paper that you can take out to your customers and test hypothesis so you can see what makes their eyes light up or what makes them fall asleep without having to actually build. So it's a little bit different than the traditional. The advantage over a prototype is that you can explore the customers needs very early in the process.", isFavourite: false, tags: []),
            TranscriptFragment(content: "Fess up it's OK. So it could be wrong. But just remember that the next time you start going into talking about your technology don't be this guy, so anyway. Your customers want the solution not the technology so again put this on a tattoo on your body. It's a very simple but important point. Customers care about their problems and their jobs.", isFavourite: true),
            TranscriptFragment(content: "A good pitch will does that. For instance, team MQuill did a great job of starting out with the job that their customer was trying to do: take notes. They were very specific and I think it really makes your pitches more powerful if when you're talking about problems.", isFavourite: true)
            ];
        
        
        transcript = TranscriptDocument(id:"2", title: "#2 Imagine Cup MVP", sequence: 2, fragments: fragments, lectureId: "IMCUP")
        try! store.save(transcript)
        
        let politics = [LectureDocument(id: "2", shortName: "ART", name: "Art and History", color: .magenta)]
        try! lectureStore.save(politics)
        
        fragments = [
            TranscriptFragment(content: "Tom Thomson (August 5, 1877) was a Canadian artist active in the early 20th century. During his short career he produced four hundred oil sketches on small wood panels along with around 50 larger works on canvas. His works consist almost entirely of landscapes depicting trees, skies, lakes, and rivers. His paintings use broad brush strokes and a liberal application of paint to capture the beauty and colour of the Ontario landscape. Thomson's accidental death at 39 by drowning came shortly before the founding of the Group of Seven and is seen as a tragedy for Canadian art.", isFavourite: false, tags: [TranscriptTag(name: .keyword, range: NSRange(location: 0, length: 11))]),
            TranscriptFragment(content: "Thomson developed a reputation during his lifetime as a veritable outdoorsman, talented in both fishing and canoeing, although his skills in the latter have been contested. The circumstances of his drowning on Canoe Lake in Algonquin Park, linked with his image as a master canoeist, led to unsubstantiated but persistent rumours that he had been murdered or committed suicide.", isFavourite: true),
            TranscriptFragment(content: "His art is typically exhibited in Canada—mainly at the Art Gallery of Ontario in Toronto, the National Gallery of Canada in Ottawa, the McMichael Canadian Art Collection in Kleinburg and the Tom Thomson Art Gallery in Owen Sound.", isFavourite: true, tags: [TranscriptTag(name: .keyword, range: NSRange(location: 55, length: 22)), TranscriptTag(name: .keyword, range: NSRange(location: 90, length: 40))])
        ];
        
        transcript = TranscriptDocument(id:"3", title: "#1 Art and History: Tom Thomson", sequence: 1, fragments: fragments, lectureId: "2")
        try! store.save(transcript)
        
        
        let math = [LectureDocument(id: "3", shortName: "MATH", name: "Mathematics", color: .orange)]
        try! lectureStore.save(math)

        
        fragments = [
            TranscriptFragment(content: "Are we on? Okay, hey, I guess we’ve started. Any questions about last time – if not, we’ll continue. I think they’re. I wonder if there’s some announcement. Let’s see, one is that Homework 1 will be due Thursday.  So I know some of you are very excited about that. The reason is we had at least a couple of people who are gonna be gone next weekend and asked us to figure out Homework 2. So we did it, and it’s figured out.", isFavourite: false, tags: []),
            TranscriptFragment(content: "I don’t think there are any more announcements. Oh, there is one more – we now have a third assignment, Thomas, who has a class at this time, so he’s not here, but he sneaks in for the last half hour. So maybe if I remember, I’ll point to him and he can wave his arms when he comes in or at the end of the class, something like that.", isFavourite: false, tags: []),
            TranscriptFragment(content: "Okay, well, let’s just continue. I need to go down to the pad. Last time we looked at linearization as a source of lots and lots of linear equations. So what does linearize mean: You have a non-linear function that maps RN into RM. And you approximate it by an affine function.", isFavourite: false, tags: []),
            TranscriptFragment(content: "Affine means linear plus a constant. That's it. In the context of calculus, people often talk about a linear approximation and what they really mean is an affine approximation. But after awhile, you get used to this. So linearization is very simple. You simply calculate the Jacobean or the derivative matrix, and what it does is it gives you an extremely good approximation of how the output varies if the input varies a little bit from some standard point, X0. That’s the idea.", isFavourite: false, tags: []),
        ];
        
        transcript = TranscriptDocument(id:"5", title: "#1 Linear Dynamical Systems", sequence: 1, fragments: fragments, lectureId: "3")
        try! store.save(transcript)
        


        let mq = [LectureDocument(id: "mq", shortName: "mq", name: "MQuill", color: .turquoise)]
        try! lectureStore.save(mq)
        
        let fragments2 = [TranscriptFragment(content: "MQuill: Lecture Capture, smart search, Q and A, a scroll away!", isFavourite: true)]
        transcript = TranscriptDocument(id:"w353454-01", title: "MQuill", sequence: 1, fragments: fragments2, lectureId: "mq")
        try! store.save(transcript)

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}


//
//  NSViewController.m
//  cTiVo
//
//  Created by Hugh Mackworth on 2/6/18.
//  Copyright © 2018 cTiVo. All rights reserved.
//

#import "MTRemoteWindowController.h"
#import "MTTiVoManager.h"
#import "NSNotificationCenter+Threads.h"

@interface MTRemoteWindowController ()
@property (nonatomic, weak) IBOutlet NSPopUpButton * tivoListPopup;
@property (nonatomic, strong) NSArray <MTTiVo *> * tiVoList;
@property (nonatomic, readonly) MTTiVo * selectedTiVo;
@property (nonatomic, weak) IBOutlet NSImageView * tivoRemote;
@property (nonatomic, weak) IBOutlet NSMenu * serviceMenu;
@end

@implementation MTRemoteWindowController

__DDLOGHERE__

-(instancetype) init {
	if ((self = [self initWithWindowNibName:@"MTRemoteWindowController"])) {
		[self updateTiVoList];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTiVoList) name:kMTNotificationTiVoListUpdated object:nil];
		
        self.window.contentAspectRatio = self.tivoRemote.image.size;
    };
	return self;
}

-(void) whatsOn {
	[self.selectedTiVo whatsOnWithCompletion:^(MTWhatsOnType whatsOn, NSString *recordingID) {
		switch (whatsOn) {
			case MTWhatsOnUnknown:
				DDLogReport(@"Tivo is showing unknown %@", recordingID);
				break;
			case MTWhatsOnLiveTV:
				DDLogReport(@"Tivo is showing live TV %@", recordingID);
				break;
			case MTWhatsOnRecording:
				DDLogReport(@"Tivo is showing a recording %@", recordingID);
				break;
			case MTWhatsOnStreamingOrMenus:
				DDLogReport(@"Tivo is in menus or streaming %@", recordingID);
				break;
			default:
				break;
		}
	}];
}
	 
-(MTTiVo *) selectedTiVo {
	MTTiVo* tivo = nil;
	if (self.tiVoList.count > 0) {
		NSInteger index = MIN(MAX(self.tivoListPopup.indexOfSelectedItem,0), ((NSInteger) self.tiVoList.count)-1);
		tivo = self.tiVoList[index];
	}
	return tivo;
}

-(void) updateTiVoList {
	NSMutableArray * newList = [NSMutableArray array];
	for (MTTiVo * tivo in [tiVoManager tiVoList]) {
		if (tivo.enabled && tivo.rpcActive) {
			[newList addObject:tivo];
		}
	}
	for (MTTiVo * tivo in [tiVoManager tiVoMinis]) {
		if (tivo.enabled && tivo.rpcActive) {
			[newList addObject:tivo];
		}
	}
	self.tiVoList = [newList copy];
}

-(IBAction)netflixButton:(NSButton *) sender {
	[NSMenu popUpContextMenu:self.serviceMenu
				   withEvent: NSApplication.sharedApplication.currentEvent
							   forView:(NSButton *)sender];
}

- (IBAction)serviceMenuSelected:(NSPopUpButton *)sender {
	NSMenuItem * item = sender.selectedItem;
	if (!item) return;
	NSDictionary * commands = @{
	  @"Netflix" 		:   @"x-tivo:netflix:netflix",
	  @"HBO Go"			: 	@"x-tivo:web:https://tivo.hbogo.com",
	  @"Amazon Prime"	: 	@"x-tivo:web:https://atv-ext.amazon.com/blast-app-hosting/html5/index.html?deviceTypeID=A3UXGKN0EORVOF",
	  @"Hulu"			: 	@"x-tivo:web:https://tivo.app.hulu.com/cube/prod/tivo/hosted/index.html",
	  @"Epix"			: 	@"x-tivo:web:https://tivoapp.epix.com/",
	  @"YouTube"		: 	@"x-tivo:web:https://www.youtube.com/tv",
	  @"Vudu"			: 	@"x-tivo:vudu:vudu",
	  @"Plex"			: 	@"x-tivo:web:https://plex.tv/web/tv/tivo",
	  
	  @"Alt TV"			: 	@"x-tivo:web:https://channels.wurl.com/launch",
	  @"AOL"			: 	@"x-tivo:web:https://ott.on.aol.com/ott/tivo_tv/homepage?secure=false",
	  @"FlixFling"		: 	@"x-tivo:web:https://tv.flixfling.com/tivo",
	  @"HSN"			: 	@"x-tivo:web:https://tivo.hsn.com/home.aspx",
	  @"iHeart Radio"	: 	@"x-tivo:web:https://tv.iheart.com/tivo/",
	  @"MLB"			: 	@"x-tivo:web:https://secure.mlb.com/ce/tivo/index.html",
	  @"Music Choice"	: 	@"x-tivo:web:https://tivo.musicchoice.com/tivo",
	  @"Toon Goggles"	: 	@"x-tivo:web:https://html5.toongoggles.com",
	  @"Tubi TV"		: 	@"x-tivo:web:https://ott-tivo.tubitv.com/",
	  @"Vevo"			: 	@"x-tivo:web:https://tivo.vevo.com/index.html",
	  @"Vewd"			: 	@"x-tivo:web:tvstore",
	  @"Wurl TV"		: 	@"x-tivo:web:http://channels.wurl.com/tune/channel/ign_e3_live?lp=tvdb",
	  @"WWE"			: 	@"x-tivo:web:https://secure.net.wwe.com/ce/tivo/index.html",
	  @"Yahoo"			: 	@"x-tivo:web:https://smarttv-screen.manhattan.yahoo.com/v2/e/production?man=tivo",
	  @"YuppTV"			: 	@"x-tivo:web:https://www.yupptv.com/tivo/index.html",

	  
//	  @"Evue": 	@"x-tivo:web:http://evueapp.evuetv.com/evuetv/tivo/init.php",  //Not authrized
//	  @"Spotify": 	@"x-tivo:web:https://d27nv3bwly96dm.cloudfront.net/indexOperav2.html",  //no reaction
//	  @"YouTube Flash" 	: @"x-tivo:flash:uuid:B8CEA236-0C3D-41DA-9711-ED220480778E",
//	  @"Amazon" 		: @"x-tivo:hme:uuid:35FE011C-3850-2228-FBC5-1B9EDBBE5863",
//	  @"Hulu Plus" 		: @"x-tivo:flash:uuid:802897EB-D16B-40C8-AEEF-0CCADB480559",
//	  @"AOL On"			: @"x-tivo:flash:uuid:EA1DEF9D-D346-4284-91A0-FEA8EAF4CD39",
//	  @"Launchpad" 		: @"x-tivo:flash:uuid:545E064D-C899-407E-9814-69A021D68DAD"
	  };
	[self.selectedTiVo sendURL: commands[item.title]];
}

-(IBAction)buttonPressed:(NSButton *)sender {
	if (!sender.title) return;
	[self.selectedTiVo sendKeyEvent: sender.title];
}

-(void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

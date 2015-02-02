//
//  AppDelegate.m
//  Workbench1
//
//  Created by Hoon H. on 2015/01/20.
//
//

#import "AppDelegate.h"
#import <LLDB/LLDB.h>


using namespace	lldb;

@interface AppDelegate ()
{
	SBDebugger	_dbg;
	SBTarget	_target;
	SBProcess	_process;
}
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)print:(SBThread)th {
	SBProcess	p	=	th.GetProcess();
	
	SBStream	m{};
	m.RedirectToFileHandle(stdout, false);
	fflush(stdout);
	
//	NSLog(@"_process.GetProcessID = %@", @(th.GetProcess().GetProcessID()));
//	NSLog(@"_process.GetState = %@", @(th.GetProcess().GetState()));
//	NSLog(@"_process.GetExitDescription = %s", th.GetProcess().GetExitDescription());
//	NSLog(@"_process.GetNumThreads = %@", @(th.GetProcess().GetNumThreads()));
//	NSLog(@"p.GetExitStatus = %@", @(p.GetExitStatus()));
//	
//	
//	NSLog(@"th.GetStopReason = %@", @(th.GetStopReason()));
//	NSLog(@"th.GetNumFrames = %@", @(th.GetNumFrames()));
	
	for (int i=0; i<th.GetNumFrames(); i++) {
		SBFrame		f	=	th.GetFrameAtIndex(i);
		f.GetDescription(m);
		
		SBValueList	vs	=	f.GetVariables(true, true, true, true);
		NSLog(@"variables = %@", @(vs.GetSize()));
	}
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	char const*	path	=	[[[[NSBundle mainBundle] bundleURL] URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"SampleProgram3"].path.UTF8String;
	
	SBDebugger::Initialize();
	
	SBStream	m{};
	m.RedirectToFileHandle(stdout, false);
	fflush(stdout);
	
	_dbg		=	SBDebugger::Create();
	_dbg.GetDescription(m);
	printf("\n");

	
	NSLog(@"%s", _dbg.GetVersionString());
	
	_target		=	_dbg.CreateTargetWithFileAndArch(path, LLDB_ARCH_DEFAULT);
	
	auto	main_bp	=	_target.BreakpointCreateByName("main", _target.GetExecutable().GetFilename());
	auto	process	=	_target.LaunchSimple(nullptr, nullptr, [[NSFileManager defaultManager] currentDirectoryPath].UTF8String);
	
	if (process.IsValid()) {
		auto	state	=	process.GetState();
		NSLog(@"process.GetState = %@", @(state));
		
		while (true) {
			if (state == eStateStopped) {
				auto	thread	=	process.GetThreadAtIndex(0);
				if (thread.IsValid()) {
					thread.GetDescription(m);
					if (thread.GetStopReason() != eStopReasonNone) {
//						thread.GetStopReasonExtendedInfoAsJSON(m);
					}
					thread.GetStatus(m);
					
					auto	frame	=	thread.GetFrameAtIndex(0);
					frame.GetDescription(m);
					
					auto	function	=	frame.GetFunction();
					function.GetDescription(m);
					
					if (function.IsValid()) {
						
						auto	insts	=	function.GetInstructions(_target);
						insts.GetDescription(m);
						
						for (int i=0; i<insts.GetSize(); i++) {
							auto	inst	=	insts.GetInstructionAtIndex(i);
							inst.GetDescription(m);
						}
					} else {
						auto	symbol	=	frame.GetSymbol();
						symbol.GetDescription(m);
					}
				}
			}
			process.Continue();
		}
	}
	
	
	SBValue	a;
	auto	b(a.GetSP());
	

//	SBSymbolContextList	sl	=	_target.FindFunctions("main");
//	
////	char const*	filename	=	sl.GetContextAtIndex(0).GetCompileUnit().GetFileSpec().GetFilename();
////	uint32_t	linenum		=	sl.GetContextAtIndex(0).GetCompileUnit().GetLineEntryAtIndex(0).get
//
//	printf("\n");
//	auto		file		=	sl.GetContextAtIndex(0).GetCompileUnit().GetFileSpec();
//	uint32_t	linenum		=	sl.GetContextAtIndex(0).GetCompileUnit().GetLineEntryAtIndex(0).GetLine();
//	
//	sl.GetDescription(m);
//	
//	printf("\n");
//	fflush(stdout);
//	
//	SBBreakpoint	bp	=	_target.BreakpointCreateByLocation(file, linenum);
//	bp.GetDescription(m);
//	printf("\n");
//	fflush(stdout);
//	
//	_target.EnableAllBreakpoints();
//
//	
//	char const*	args[]	=	{"A", nullptr};
//	char const*	env[]	=	{"A", nullptr};
//
//	_process	=	_target.LaunchSimple(args, env, [[NSFileManager defaultManager] currentDirectoryPath].UTF8String);
//	_process.GetDescription(m);
//	printf("\n");
//	
////	auto	err1	=	_process.Continue();
////	err1.GetDescription(m);
////	_process.GetDescription(m);
////	fflush(stdout);
////	
////	char	buffer[1024];
////	size_t	len	=	_process.GetSTDOUT(buffer, 1024);
////	buffer[len]	=	0;
////	printf("%s\n", buffer);
////	fflush(stdout);
////	
////	sleep(3);
////	_process.GetDescription(m);
////	printf("\n");
////	fflush(stdout);
//	
//	while ( true) {
//		for (int i=0; i<_process.GetNumThreads(); i++) {
//			auto	th	=	_process.GetThreadAtIndex(i);
////			th.GetDescription(m);
//			th.StepInto();
//			auto	nf	=	th.GetNumFrames();
//			if (nf > 0) {
//				NSLog(@"%@", @(nf));
//			}
//		}
//	}

//	SBThread	th	=	_process.GetThreadAtIndex(0);
//	th.GetDescription(m);
//	printf("\n");
//	[self print:th];
//	
//	while (true) {
//		th.StepOver();
//		th.GetStatus(m);
//		[self print:th];
//		fflush(stdout);
//	}
	
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	_process.Destroy();
	_dbg.DeleteTarget(_target);
	SBDebugger::Destroy(_dbg);
	SBDebugger::Terminate();
}

@end

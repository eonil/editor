//
//  LLDBDeclarations.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#import "LLDBDeclarations.h"
#include <type_traits>
#import "LLDB_Internals.h"

static_assert(std::is_same<LLDBAddressType, lldb::addr_t>::value, "One of more typedef to C++ numeric type doesn't match.");
static_assert(std::is_same<LLDBThreadIDType, lldb::tid_t>::value, "One of more typedef to C++ numeric type doesn't match.");
static_assert(std::is_same<LLDBProcessIDType, lldb::pid_t>::value, "One of more typedef to C++ numeric type doesn't match.");
static_assert(std::is_same<LLDBQueueIDType, lldb::queue_id_t>::value, "One of more typedef to C++ numeric type doesn't match.");
static_assert(std::is_same<LLDBBreakpointIDType, lldb::break_id_t>::value, "One of more typedef to C++ numeric type doesn't match.");
static_assert(std::is_same<LLDBOffsetType, lldb::offset_t>::value, "One of more typedef to C++ numeric type doesn't match.");
static_assert(std::is_same<LLDBUserIDType, lldb::user_id_t>::value, "One of more typedef to C++ numeric type doesn't match.");
static_assert(std::is_same<LLDBWatchIDType, lldb::watch_id_t>::value, "One of more typedef to C++ numeric type doesn't match.");

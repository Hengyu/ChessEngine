/*
 Stockfish, a chess program for iOS.
 Copyright (C) 2004-2014 Tord Romstad, Marco Costalba, Joona Kiiski.
 
 Stockfish is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Stockfish is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 This file `iosextension.mm` is modified from the original file `iphone.mm` of the opensource project Stockfish for iOS. Main modifications are for  optimizing for Stockfish 8.
 Since iOS not only runs on iPhone, iPod touch but runs on iPad as well. So I renamed the originial name `iphone` to `iosextension`.
 */

//
//  iosextension.mm
//  ChessEngine
//
//  Created by hengyu on 2017/2/12.
//  Copyright © 2017 hengyu. All rights reserved.
//

#import "EngineController.h"

#include <iomanip>
#include <sstream>

#include "bitboard.h"
#include "search.h"
#include "thread.h"
#include "tt.h"
#include "uci.h"
#include "syzygy/tbprobe.h"

// PSQT is in Stockfish 8
namespace PSQT {
    void init();
}

using std::string;

namespace {
    string CurrentMove;
    int CurrentMoveNumber;
    int TotalMoveCount;
    int CurrentDepth;
}

void engine_init() {
    UCI::init(Options);
    PSQT::init();
    Bitboards::init();
    Position::init();
    Bitbases::init();
    Search::init();
    Pawns::init();
    Threads.init();
    Tablebases::init(Options["SyzygyPath"]);
    TT.resize(Options["Hash"]);
}


void engine_exit() {
    Search::clear();
    Threads.exit();
}


void pv_to_ui(const string &pv, int depth, int score, int scoreType, bool mate) {
    NSString *string = [[NSString alloc] initWithUTF8String: pv.c_str()];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SharedEngineController sendPrincipalVariation:string];
    });
}

void pv_to_ui2(const string &pv) {
    NSString *string = [[NSString alloc] initWithUTF8String: pv.c_str()];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SharedEngineController sendPrincipalVariation:string];
    });
}


void currmove_to_ui(const string currmove, int currmovenum, int movenum, int depth) {
    CurrentMove = currmove;
    CurrentMoveNumber = currmovenum;
    CurrentDepth = depth;
    TotalMoveCount = movenum;
    
    NSString *move = [[NSString alloc] initWithUTF8String:currmove.c_str()];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SharedEngineController sendCurrentMove:move number:CurrentMoveNumber depth:CurrentDepth totalMoves:TotalMoveCount];
    });
}

static const string time_string(int millisecs) {
    
    const int MSecMinute = 1000 * 60;
    const int MSecHour   = 1000 * 60 * 60;
    
    std::stringstream s;
    s << std::setfill('0');
    
    int hours = millisecs / MSecHour;
    int minutes = (millisecs - hours * MSecHour) / MSecMinute;
    int seconds = (millisecs - hours * MSecHour - minutes * MSecMinute) / 1000;
    
    if (hours)
        s << hours << ':';
    
    s << std::setw(2) << minutes << ':' << std::setw(2) << seconds;
    return s.str();
}

void searchstats_to_ui(int64_t nodes, long time) {
    
    std::stringstream s;
    s << " " << time_string((int)time) << "  " << CurrentDepth
    << "  " << CurrentMove
    << " (" << CurrentMoveNumber << "/" << TotalMoveCount << ")"
    << "  ";
    if (nodes < 1000000000)
        s << nodes/1000 << "kN";
    else
        s << std::setiosflags(std::ios::fixed) << std::setprecision(1) << nodes/1000000.0 << "MN";
    if(time > 0)
        s << std::setiosflags(std::ios::fixed) << std::setprecision(1)
        << "  " <<  (nodes*1.0) / time << "kN/s";
    
    NSString *string = [[NSString alloc] initWithUTF8String: s.str().c_str()];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SharedEngineController sendSearchingStatus:string];
    });
}


void bestmove_to_ui(const string &best, const string &ponder) {
    NSString *bestString = [[NSString alloc] initWithUTF8String: best.c_str()];
    NSString *ponderString;
    if (!ponder.empty()) {
        ponderString = [[NSString alloc] initWithUTF8String: ponder.c_str()];
    } else {
        ponderString = nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SharedEngineController sendBestMove:bestString ponderMove:ponderString];
    });
}


extern void execute_command(const string &command);

void command_to_engine(const string &command) {
    execute_command(command);
}

bool command_is_waiting() {
    return [SharedEngineController commandIsWaiting];
}

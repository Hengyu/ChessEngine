/*
 Stockfish, a chess program for iOS.
 Copyright (C) 2004-2013 Tord Romstad, Marco Costalba, Joona Kiiski.
 
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
 This file `iosextension.h` is modified from the original file `iphone.h` of the opensource project Stockfish for iOS.
 Since iOS not only runs on iPhone, iPod touch but runs on iPad as well. So I renamed the originial name `iphone` to `iosextension`.
 */

//
//  iosextension.h
//  ChessEngine
//
//  Created by hengyu on 2017/2/12.
//  Copyright © 2017 hengyu. All rights reserved.
//

#include <stdio.h>
#include <iomanip>
#include <string>
#include <sstream>

extern void engine_init();
extern void engine_exit();
extern void pv_to_ui2(const std::string &pv);
extern void currmove_to_ui(const std::string currmove, int currmovenum,
                           int movenum, int depth);
extern void bestmove_to_ui(const std::string &best, const std::string &ponder);
extern void searchstats_to_ui(int64_t nodes, long time);
extern int get_command(std::string &cmd);
extern void command_to_engine(const std::string &command);
extern void wake_up_listener();
extern void execute_command(const std::string &cmd);


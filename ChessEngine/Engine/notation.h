//
//  notation.hpp
//  Test
//
//  Created by hengyu on 2017/2/10.
//  Copyright © 2017 hengyu. All rights reserved.
//

#ifndef NOTATION_H_INCLUDED
#define NOTATION_H_INCLUDED

#include <string>

#include "types.h"

class Position;

std::string score_to_uci(Value v, Value alpha = -VALUE_INFINITE, Value beta = VALUE_INFINITE);
Move move_from_uci(const Position& pos, std::string& str);
const std::string move_to_uci(Move m, bool chess960);
const std::string move_to_san(Position& pos, Move m);
//std::string pretty_pv(Position& pos, int depth, Value score, int64_t msecs, Move pv[]);

#endif // #ifndef NOTATION_H_INCLUDED

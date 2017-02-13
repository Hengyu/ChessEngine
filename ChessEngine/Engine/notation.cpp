//
//  notation.cpp
//  Test
//
//  Created by hengyu on 2017/2/10.
//  Copyright © 2017 hengyu. All rights reserved.
//

#include <cassert>
#include <iomanip>
#include <sstream>
#include <stack>

#include "movegen.h"
#include "notation.h"
#include "position.h"

using namespace std;

static const char* PieceToChar[COLOR_NB] = { " PNBRQK", " pnbrqk" };

/// score_to_uci() converts a value to a string suitable for use with the UCI
/// protocol specifications:
///
/// cp <x>     The score from the engine's point of view in centipawns.
/// mate <y>   Mate in y moves, not plies. If the engine is getting mated
///            use negative values for y.

string score_to_uci(Value v, Value alpha, Value beta) {
    
    stringstream ss;
    
    if (abs(v) < VALUE_MATE_IN_MAX_PLY)
        ss << "cp " << v * 100 / PawnValueEg;
    else
        ss << "mate " << (v > 0 ? VALUE_MATE - v + 1 : -VALUE_MATE - v) / 2;
    
    ss << (v >= beta ? " lowerbound" : v <= alpha ? " upperbound" : "");
    
    return ss.str();
}

// This function is integrated in the new version of `uci.cpp`.

/// move_to_uci() converts a move to a string in coordinate notation
/// (g1f3, a7a8q, etc.). The only special case is castling moves, where we print
/// in the e1g1 notation in normal chess mode, and in e1h1 notation in chess960
/// mode. Internally castling moves are always encoded as "king captures rook".

const string move_to_uci(Move m, bool chess960) {
    
    Square from = from_sq(m);
    Square to = to_sq(m);
    
    if (m == MOVE_NONE)
        return "(none)";
    
    if (m == MOVE_NULL)
        return "0000";
    
    if (type_of(m) == CASTLING && !chess960)
        to = make_square(to > from ? FILE_G : FILE_C, rank_of(from));
    
    string move = to_string(from) + to_string(to);
    
    if (type_of(m) == PROMOTION)
        move += PieceToChar[BLACK][promotion_type(m)]; // Lower case
    
    return move;
}

// This function is integrated in the new version of `uci.cpp`.

/// move_from_uci() takes a position and a string representing a move in
/// simple coordinate notation and returns an equivalent legal Move if any.

Move move_from_uci(const Position& pos, string& str) {
    
    if (str.length() == 5) // Junior could send promotion piece in uppercase
        str[4] = char(tolower(str[4]));
    
    for (const auto& m : MoveList<LEGAL>(pos))
        if (str == move_to_uci(m, pos.is_chess960()))
            return m;
    
    return MOVE_NONE;
}

/// move_to_san() takes a position and a legal Move as input and returns its
/// short algebraic notation representation.

const string move_to_san(Position& pos, Move m) {
    
    if (m == MOVE_NONE)
        return "(none)";
    
    if (m == MOVE_NULL)
        return "(null)";
    
    //assert(MoveList<LEGAL>(pos).contains(m));
    
    Bitboard others, b;
    string san;
    Color us = pos.side_to_move();
    Square from = from_sq(m);
    Square to = to_sq(m);
    Piece pc = pos.piece_on(from);
    PieceType pt = type_of(pc);
    
    if (type_of(m) == CASTLING)
        san = to > from ? "O-O" : "O-O-O";
    else
    {
        if (pt != PAWN)
        {
            san = PieceToChar[WHITE][pt]; // Upper case
            
            // A disambiguation occurs if we have more then one piece of type 'pt'
            // that can reach 'to' with a legal move.
            others = b = (pos.attacks_from(pc, to) & pos.pieces(us, pt)) ^ from;
            
            while (b)
            {
                Square s = pop_lsb(&b);
                if (!pos.legal(make_move(s, to)))
                    others ^= s;
            }
            
            if (!others)
            { /* Disambiguation is not needed */ }
            
            else if (!(others & file_bb(from)))
                san += to_char(file_of(from));
            
            else if (!(others & rank_bb(from)))
                san += to_char(rank_of(from));
            
            else
                san += to_string(from);
        }
        else if (pos.capture(m))
            san = to_char(file_of(from));
        
        if (pos.capture(m))
            san += 'x';
        
        san += to_string(to);
        
        if (type_of(m) == PROMOTION)
            san += string("=") + PieceToChar[WHITE][promotion_type(m)];
    }
    
    if (pos.gives_check(m))
    {
        StateInfo st;
        pos.do_move(m, st);
        san += MoveList<LEGAL>(pos).size() ? "+" : "#";
        pos.undo_move(m);
    }
    
    return san;
}

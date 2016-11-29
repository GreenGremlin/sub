#!/bin/bash
#
# Constants and functions for terminal colors.
# Author: Max Tsepkov <max@yogi.pw>

CLR_ESC="\033["

# All these variables has a function with the same name, but in lower case.
#
CLR_RESET=0             # reset all attributes to their defaults
CLR_RESET_UNDERLINE=24  # underline off
CLR_RESET_REVERSE=27    # reverse off
CLR_DEFAULT=39          # set underscore off, set default foreground color

CLR_BOLD=1              # set bold
CLR_BRIGHT=2            # set half-bright (simulated with color on a color display)
CLR_UNDERSCORE=4        # set underscore (simulated with color on a color display)
CLR_REVERSE=7           # set reverse video

CLR_BLACK=30            # set black foreground
CLR_RED=31              # set red foreground
CLR_GREEN=32            # set green foreground
CLR_YELLOW=33           # set yellow foreground
CLR_BLUE=34             # set blue foreground
CLR_MAGENTA=35          # set magenta foreground
CLR_CYAN=36             # set cyan foreground
CLR_WHITE=37            # set white foreground

CLR_BG_DEFAULT=49       # set default background color
CLR_BG_BLACK=40         # set black background
CLR_BG_RED=41           # set red background
CLR_BG_GREEN=42         # set green background
CLR_BG_YELLOW=43        # set yellow background
CLR_BG_BLUE=44          # set blue background
CLR_BG_MAGENTA=45       # set magenta background
CLR_BG_CYAN=46          # set cyan background
CLR_BG_WHITE=47         # set white background

# General function to wrap string with escape sequence(s).
# Ex: clr_escape foobar $CLR_RED $CLR_BOLD
function clr_escape
{
    local result="$1"
    until [ -z "$2" ]; do
    if ! [ $2 -ge 0 -a $2 -le 47 ] 2>/dev/null; then
        echo "clr_escape: argument \"$2\" is out of range" >&2 && return 1
    fi
        result="${CLR_ESC}${2}m${result}${CLR_ESC}${CLR_RESET}m"
    shift || break
    done

    echo -e "$result"
}

function clr_reset           { clr_escape "$1" $CLR_RESET;           }
function clr_reset_underline { clr_escape "$1" $CLR_RESET_UNDERLINE; }
function clr_reset_reverse   { clr_escape "$1" $CLR_RESET_REVERSE;   }
function clr_default         { clr_escape "$1" $CLR_DEFAULT;         }
function clr_bold            { clr_escape "$1" $CLR_BOLD;            }
function clr_bright          { clr_escape "$1" $CLR_BRIGHT;          }
function clr_underscore      { clr_escape "$1" $CLR_UNDERSCORE;      }
function clr_reverse         { clr_escape "$1" $CLR_REVERSE;         }
function clr_black           { clr_escape "$1" $CLR_BLANK;           }
function clr_red             { clr_escape "$1" $CLR_RED;             }
function clr_green           { clr_escape "$1" $CLR_GREEN;           }
function clr_yellow          { clr_escape "$1" $CLR_YELLOW;          }
function clr_blue            { clr_escape "$1" $CLR_BLUE;            }
function clr_magenta         { clr_escape "$1" $CLR_MAGENTA;         }
function clr_cyan            { clr_escape "$1" $CLR_CYAN;            }
function clr_white           { clr_escape "$1" $CLR_WHITE;           }
function clr_bg_default      { clr_escape "$1" $CLR_BG_DEFAULT;      }
function clr_bg_black        { clr_escape "$1" $CLR_BG_BLACK;        }
function clr_bg_red          { clr_escape "$1" $CLR_BG_RED;          }
function clr_bg_green        { clr_escape "$1" $CLR_BG_GREEN;        }
function clr_bg_yellow       { clr_escape "$1" $CLR_BG_YELLOW;       }
function clr_bg_blue         { clr_escape "$1" $CLR_BG_BLUE;         }
function clr_bg_magenta      { clr_escape "$1" $CLR_BG_MAGENTA;      }
function clr_bg_cyan         { clr_escape "$1" $CLR_BG_CYAN;         }
function clr_bg_white        { clr_escape "$1" $CLR_BG_WHITE;        }
